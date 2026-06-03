import os
import sys
import json
import traceback
import subprocess
import fnmatch
import shlex
from pathlib import Path
from utils.env_profiler import EnvProfiler
from utils.git_helper import GitHelper
from utils.socket_proxy import SocketProxy
from utils.docker_helper import DockerHelper
from utils.db_helper import DbHelper

def debug_log(msg: str):
    """Logs debug information to stderr so it doesn't corrupt stdout JSON-RPC communication."""
    sys.stderr.write(f"[DEBUG] {msg}\n")
    sys.stderr.flush()

class McpServer:
    def __init__(self):
        self.workspace_path = Path(os.getcwd()).resolve()

    def handle_request(self, req: dict) -> dict:
        method = req.get("method")
        req_id = req.get("id")

        if method == "initialize":
            # Dynamically resolve workspace root folder from client initial connection payload
            params = req.get("params", {})
            root_uri = params.get("rootUri")
            if root_uri and root_uri.startswith("file://"):
                self.workspace_path = Path(root_uri[7:]).resolve()
            elif params.get("workspaceFolders"):
                folders = params.get("workspaceFolders", [])
                if folders:
                    uri = folders[0].get("uri", "")
                    if uri.startswith("file://"):
                        self.workspace_path = Path(uri[7:]).resolve()
            
            debug_log(f"Initialized workspace path dynamically resolved to: {self.workspace_path}")
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {},
                    "serverInfo": {
                        "name": "isolated-subagent-runner",
                        "version": "1.0.0"
                    }
                }
            }

        elif method == "tools/list":
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "result": {
                    "tools": [
                        {
                            "name": "execute_subagent_task",
                            "description": "Runs an isolated subagent task using OpenCode inside a secure sandbox container.",
                            "inputSchema": {
                                "type": "object",
                                "properties": {
                                    "task_id": {"type": "string"},
                                    "summary": {"type": "string"},
                                    "files_to_read": {"type": "array", "items": {"type": "string"}},
                                    "instructions": {
                                        "type": "array",
                                        "items": {
                                            "type": "object",
                                            "properties": {
                                                "file_path": {"type": "string"},
                                                "action": {"type": "string", "enum": ["CREATE", "MODIFY", "DELETE"]},
                                                "description": {"type": "string"}
                                            },
                                            "required": ["file_path", "action", "description"]
                                        }
                                    },
                                    "migration_file_globs": {"type": "array", "items": {"type": "string"}},
                                    "db_setup_commands": {"type": "array", "items": {"type": "string"}},
                                    "verification_commands": {"type": "array", "items": {"type": "string"}},
                                    "resource_bounds": {
                                        "type": "object",
                                        "properties": {
                                            "max_steps": {"type": "integer"},
                                            "timeout_seconds": {"type": "integer"}
                                        },
                                        "required": ["max_steps", "timeout_seconds"]
                                    },
                                    "environment_requirements": {
                                        "type": "object",
                                        "properties": {
                                            "database": {"type": "string"},
                                            "forward_credentials": {"type": "array", "items": {"type": "string"}},
                                            "environment_overrides": {"type": "object"}
                                        },
                                        "required": ["database", "forward_credentials"]
                                    }
                                },
                                "required": [
                                    "task_id", "summary", "files_to_read", "instructions", 
                                    "migration_file_globs", "db_setup_commands", "verification_commands", 
                                    "resource_bounds", "environment_requirements"
                                ]
                            }
                        }
                    ]
                }
            }

        elif method == "tools/call":
            params = req.get("params", {})
            name = params.get("name")
            arguments = params.get("arguments", {})

            if name == "execute_subagent_task":
                try:
                    result_text = self.execute_task(arguments)
                    return {
                        "jsonrpc": "2.0",
                        "id": req_id,
                        "result": {
                            "content": [
                                {
                                    "type": "text",
                                    "text": result_text
                                }
                            ]
                        }
                    }
                except Exception as e:
                    debug_log(f"Error executing task: {traceback.format_exc()}")
                    return {
                        "jsonrpc": "2.0",
                        "id": req_id,
                        "error": {
                            "code": -32603,
                            "message": f"Task execution failed: {str(e)}"
                        }
                    }

        return {
            "jsonrpc": "2.0",
            "id": req_id,
            "error": {
                "code": -32601,
                "message": f"Method not found: {method}"
            }
        }

    def execute_task(self, args: dict) -> str:
        # Schema validation & parsing
        task_id = args["task_id"]
        summary = args["summary"]
        files_to_read = args["files_to_read"]
        instructions = args["instructions"]
        migration_file_globs = args["migration_file_globs"]
        db_setup_commands = args["db_setup_commands"]
        verification_commands = args["verification_commands"]
        resource_bounds = args["resource_bounds"]
        env_reqs = args["environment_requirements"]

        max_steps = resource_bounds["max_steps"]
        timeout_seconds = resource_bounds["timeout_seconds"]

        database = env_reqs["database"]
        forward_creds = env_reqs["forward_credentials"]
        env_overrides = env_reqs.get("environment_overrides", {})

        # Configuration pathways
        worktree_dir = self.workspace_path / ".agent" / "worktrees" / task_id
        host_socket_dir = self.workspace_path / ".agent" / "sockets" / task_id
        host_socket_path = host_socket_dir / "ssh.sock"
        network_name = f"sdd-net-{task_id}"

        # Initialize helpers
        profiler = EnvProfiler(str(self.workspace_path))
        git_helper = GitHelper(str(self.workspace_path))
        db_helper = DbHelper(engine=profiler.check_container_engine())
        docker_helper = DockerHelper(engine=profiler.check_container_engine())

        debug_log(f"Starting SDD task execution pipeline for Task ID: {task_id}")

        # Step 1: Initialization & Environment Profiling
        profile = profiler.profile()
        if not profile["ready"]:
            raise RuntimeError(profile["error_msg"])

        # Step 2: Headless Isolation Snapshot
        debug_log("Taking headless isolated workspace snapshot...")
        snapshot_commit = git_helper.create_snapshot(task_id)

        # Step 3: Spawn Worktree
        debug_log(f"Spawning Git worktree at {worktree_dir}...")
        if worktree_dir.exists():
            git_helper.remove_worktree(str(worktree_dir))
        git_helper.add_worktree(str(worktree_dir), snapshot_commit)

        # Step 4: Ephemeral Socket Proxy for credentials isolation
        proxy = None
        ssh_auth_sock = os.environ.get("SSH_AUTH_SOCK")
        if ssh_auth_sock and "ssh-agent" in forward_creds:
            debug_log("Starting credentials forwarding socket proxy...")
            proxy = SocketProxy(str(host_socket_path), ssh_auth_sock)
            proxy.start()
        else:
            host_socket_dir.mkdir(parents=True, exist_ok=True)

        db_container = None
        container_name = None
        db_env = {}

        try:
            # Step 5: Start Companion Database
            if database and database.lower() != "none":
                debug_log(f"Spawning companion DB service ({database})...")
                db_container, db_env = db_helper.start_database_service(
                    task_id=task_id,
                    database_type=database,
                    network_name=network_name,
                    overrides=env_overrides
                )

            # Step 6: Start Sandbox Container
            debug_log("Booting isolated sandbox container...")
            container_name = docker_helper.start_container(
                task_id=task_id,
                worktree_path=str(worktree_dir),
                host_socket_dir=str(host_socket_dir),
                volume_strategy=profile["volume_strategy"]
            )

            # Connect containers to bridge network
            if db_container:
                db_helper.run_cmd(["network", "connect", network_name, container_name])

            # Step 7: Pre-Edit DB migration/setup command runs
            if db_setup_commands:
                debug_log("Running initial DB baseline migrations...")
                for cmd in db_setup_commands:
                    code, out, err = docker_helper.exec_in_container(
                        container_name, shlex.split(cmd), env=db_env, timeout=120
                    )
                    if code != 0:
                        raise RuntimeError(f"Database baseline setup failed: {cmd}\nExit: {code}\nStdout: {out}\nStderr: {err}")

            # Step 8: Execution Loop (Invoke OpenCode inside container)
            debug_log("Writing task.json configuration...")
            task_json_dir = worktree_dir / ".agent"
            task_json_dir.mkdir(parents=True, exist_ok=True)
            with open(task_json_dir / "task.json", "w") as f:
                json.dump({
                    "task_id": task_id,
                    "summary": summary,
                    "instructions": instructions,
                    "files_to_read": files_to_read
                }, f, indent=2)

            # Forward OpenCode credentials and settings from host to container
            runner_env = db_env.copy() if db_env else {}
            for var_name in ["OPENCODE_API_KEY", "OPENCODE_API_URL", "OPENCODE_MODEL"]:
                if var_name in os.environ:
                    runner_env[var_name] = os.environ[var_name]

            debug_log("Executing subagent runner inside sandbox...")
            runner_code, runner_out, runner_err = docker_helper.exec_in_container(
                container_name=container_name,
                cmd=["python3", "/workspace/mcp-servers/isolated-subagent-runner/agent/opencode_runner.py", "/workspace/.agent/task.json"],
                env=runner_env,
                timeout=timeout_seconds
            )

            task_result_path = task_json_dir / "task_result.json"
            if not task_result_path.exists():
                raise RuntimeError(f"Subagent runner failed to generate task result. Exit code: {runner_code}\nStdout: {runner_out}\nStderr: {runner_err}")

            with open(task_result_path, "r") as f:
                task_result = json.load(f)

            if not task_result.get("success", False):
                raise RuntimeError(f"Subagent task failed: {json.dumps(task_result.get('logs'), indent=2)}")

            # Step 8.5: Post-Edit Migration Validation & Idempotency Safeguards
            if migration_file_globs and db_setup_commands and database and database.lower() != "none":
                debug_log("Checking if migration files changed...")
                if self.check_migrations_changed(worktree_dir, migration_file_globs):
                    debug_log("Migration files changed. Triggering conditional DB catch-up...")
                    try:
                        # Attempt standard catch-up by re-running setup/migration commands
                        for cmd in db_setup_commands:
                            code, out, err = docker_helper.exec_in_container(
                                container_name, shlex.split(cmd), env=db_env, timeout=120
                            )
                            if code != 0:
                                raise RuntimeError(f"Catch-up command failed: {cmd}\nExit: {code}\nErr: {err}")
                        debug_log("Database catch-up migrations executed successfully.")
                    except Exception as e:
                        debug_log(f"Catch-up migration failed ({e}). Initiating database force-reset self-healing...")
                        # 1. Stop and remove current database container
                        db_helper.run_cmd(["stop", db_container])
                        db_helper.run_cmd(["rm", "-f", db_container])
                        
                        # 2. Spin up fresh database container
                        db_container, db_env = db_helper.start_database_service(
                            task_id=task_id,
                            database_type=database,
                            network_name=network_name,
                            overrides=env_overrides
                        )
                        
                        # 3. Connect sandbox container to the new database container
                        db_helper.run_cmd(["network", "connect", network_name, container_name])
                        
                        # 4. Re-run all DB setup commands from scratch (re-seeding)
                        debug_log("Re-running all database setup commands from scratch on fresh DB...")
                        for cmd in db_setup_commands:
                            code, out, err = docker_helper.exec_in_container(
                                container_name, shlex.split(cmd), env=db_env, timeout=120
                            )
                            if code != 0:
                                raise RuntimeError(f"Database reset self-healing failed: {cmd}\nExit: {code}\nStdout: {out}\nStderr: {err}")
                        debug_log("Database self-healing reset completed successfully.")

            # Step 8.9: Verification and Asynchronous Branch Staging
            if verification_commands:
                debug_log("Running project verification commands...")
                for cmd in verification_commands:
                    code, out, err = docker_helper.exec_in_container(
                        container_name, shlex.split(cmd), env=db_env, timeout=180
                    )
                    if code != 0:
                        raise RuntimeError(f"Verification command failed: {cmd}\nExit: {code}\nStdout: {out}\nStderr: {err}")
                debug_log("All verification commands passed successfully.")

            # Stage and commit validated changes inside the worktree
            debug_log("Committing changes in isolated worktree...")
            subprocess.run(
                ["git", "add", "-A"],
                cwd=str(worktree_dir),
                capture_output=True,
                text=True
            )
            
            commit_msg = f"SDD Validated Changes for Task {task_id}"
            subprocess.run(
                ["git", "commit", "-m", commit_msg],
                cwd=str(worktree_dir),
                capture_output=True,
                text=True
            )
            
            # Resolve the commit hash generated in the worktree
            rev_res = subprocess.run(["git", "rev-parse", "HEAD"], cwd=str(worktree_dir), capture_output=True, text=True)
            validated_commit = rev_res.stdout.strip()

            # Create or update the staging branch on the main repository pointing to this validated commit
            branch_name = f"sdd/{task_id}"
            branch_res = subprocess.run(
                ["git", "branch", "-f", branch_name, validated_commit],
                cwd=str(self.workspace_path),
                capture_output=True,
                text=True
            )
            if branch_res.returncode != 0:
                raise RuntimeError(f"Failed to create staging branch {branch_name}: {branch_res.stderr.strip()}")

            debug_log(f"Staged changes on local branch: {branch_name}")

            return (
                f"Subagent task completed successfully and passed all verification checks!\n\n"
                f"Changes staged in branch: {branch_name}\n"
                f"To review and merge these changes into your active workspace, run:\n"
                f"  git merge {branch_name}\n\n"
                f"Logs:\n{json.dumps(task_result.get('logs'), indent=2)}"
            )

        finally:
            # Cleanup
            debug_log("Tearing down sandbox execution context...")
            if container_name:
                docker_helper.stop_container(container_name)
            if db_container:
                db_helper.stop_database_service(db_container, network_name)
            if proxy:
                proxy.stop()
            
            # Clean directory remains
            try:
                host_socket_dir.rmdir()
            except Exception:
                pass
            try:
                host_socket_dir.parent.rmdir()
            except Exception:
                pass

            git_helper.remove_worktree(str(worktree_dir))
            try:
                worktree_dir.parent.rmdir()
            except Exception:
                pass

            subprocess.run(["git", "update-ref", "-d", f"refs/sdd/snapshots/{task_id}"], cwd=str(self.workspace_path), capture_output=True)
    def check_migrations_changed(self, worktree_dir: Path, migration_globs: list) -> bool:
        """Runs git status inside the worktree and matches modified files against the migration glob patterns."""
        res = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=str(worktree_dir),
            capture_output=True,
            text=True
        )
        if res.returncode != 0:
            return False
        
        changed_files = []
        for line in res.stdout.splitlines():
            if len(line) > 3:
                # git status --porcelain formats output as: XY path
                filepath = line[3:].strip()
                # strip potential git escape quotes
                if filepath.startswith('"') and filepath.endswith('"'):
                    filepath = filepath[1:-1]
                changed_files.append(filepath)

        for filepath in changed_files:
            for pattern in migration_globs:
                if fnmatch.fnmatch(filepath, pattern):
                    return True
        return False

    def run(self):
        """Stdio processing loop."""
        try:
            for line in sys.stdin:
                if not line.strip():
                    continue
                req = json.loads(line)
                res = self.handle_request(req)
                sys.stdout.write(json.dumps(res) + "\n")
                sys.stdout.flush()
        except KeyboardInterrupt:
            pass
        except Exception as e:
            debug_log(f"Fatal error in stdio loop: {traceback.format_exc()}")

if __name__ == "__main__":
    server = McpServer()
    server.run()
