import subprocess
from pathlib import Path
from typing import Tuple, Optional, Dict

class DockerHelper:
    def __init__(self, engine: str = "docker"):
        """
        Initializes the container helper.
        :param engine: 'docker' or 'podman'
        """
        self.engine = engine

    def run_cmd(self, args: list, timeout: Optional[int] = None) -> subprocess.CompletedProcess:
        """Runs a command with the selected container engine."""
        return subprocess.run(
            [self.engine] + args,
            capture_output=True,
            text=True,
            timeout=timeout
        )

    def create_cache_volume(self, volume_name: str = "sdd-package-cache"):
        """Creates the named cache volume if it doesn't already exist."""
        res = self.run_cmd(["volume", "inspect", volume_name])
        if res.returncode != 0:
            self.run_cmd(["volume", "create", volume_name])

    def start_container(
        self,
        task_id: str,
        worktree_path: str,
        host_socket_dir: str,
        volume_strategy: str,
        image_name: str = "isolated-runner:latest"
    ) -> str:
        """
        Spawns the isolated sandbox container, mounts the workspace, socket proxies, 
        and named cache volumes. Returns the container name.
        """
        container_name = f"sdd-sandbox-{task_id}"
        worktree_path = str(Path(worktree_path).resolve())
        host_socket_dir = str(Path(host_socket_dir).resolve())

        # Construct basic execution arguments
        args = [
            "run", "-d",
            "--name", container_name,
            # Mount the Git worktree workspace with Fedora SELinux context flags (:z)
            "-v", f"{worktree_path}:/workspace:z",
            # Mount the Unix domain socket proxy folder with Fedora SELinux context flags (:z)
            "-v", f"{host_socket_dir}:/var/run/agent-proxy:z",
            # Route SSH auth requests through the mounted proxy socket
            "-e", "SSH_AUTH_SOCK=/var/run/agent-proxy/ssh.sock",
            # Ensure execution runs as non-root user 'agent'
            "--user", "1000:1000",
            # Run in isolated bridge network
            "--network", "bridge"
        ]

        # Configure volume caching based on virtualization profiles
        if volume_strategy == "named_volume":
            self.create_cache_volume("sdd-package-cache")
            args += ["-v", "sdd-package-cache:/home/agent/.cache:z"]
        else:
            # Bind mount native directory for local cache under home folder
            cache_dir = Path.home() / ".cache" / "sdd-package-cache"
            cache_dir.mkdir(parents=True, exist_ok=True)
            args += ["-v", f"{cache_dir}:/home/agent/.cache:z"]

        # Spin container up with a persistent process (tail -f) so it remains running
        args += [image_name, "tail", "-f", "/dev/null"]

        res = self.run_cmd(args)
        if res.returncode != 0:
            raise RuntimeError(f"Failed to start container: {res.stderr.strip()}")
        
        return container_name

    def stop_container(self, container_name: str):
        """Stops and removes the container."""
        self.run_cmd(["stop", container_name])
        self.run_cmd(["rm", "-f", container_name])

    def exec_in_container(
        self,
        container_name: str,
        cmd: list,
        env: Optional[Dict[str, str]] = None,
        timeout: Optional[int] = None
    ) -> Tuple[int, str, str]:
        """Runs a command inside the running sandbox container."""
        args = ["exec"]
        if env:
            for k, v in env.items():
                args += ["-e", f"{k}={v}"]
        args += [container_name] + cmd

        try:
            res = self.run_cmd(args, timeout=timeout)
            return res.returncode, res.stdout, res.stderr
        except subprocess.TimeoutExpired as e:
            # Return a timeout code (e.g. 124, standard for timeout) and error logs
            return 124, "", f"Command timed out after {timeout} seconds: {e}"
