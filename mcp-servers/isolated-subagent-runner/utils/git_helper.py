import os
import shutil
import subprocess
from pathlib import Path
from typing import Optional, Dict

class GitHelper:
    def __init__(self, workspace_path: str):
        self.workspace_path = Path(workspace_path).resolve()

    def run_git(self, args: list, env: Optional[Dict[str, str]] = None) -> subprocess.CompletedProcess:
        """Helper to run git commands in the workspace."""
        current_env = os.environ.copy()
        if env:
            current_env.update(env)
        return subprocess.run(
            ["git"] + args,
            cwd=str(self.workspace_path),
            capture_output=True,
            text=True,
            env=current_env
        )

    def get_head_commit(self) -> str:
        """Resolves the current HEAD commit hash."""
        res = self.run_git(["rev-parse", "HEAD"])
        if res.returncode != 0:
            raise RuntimeError(f"Failed to resolve HEAD commit: {res.stderr.strip()}")
        return res.stdout.strip()

    def is_dirty(self) -> bool:
        """Checks if the working directory has modified, deleted, or untracked files."""
        res = self.run_git(["status", "--porcelain"])
        if res.returncode != 0:
            raise RuntimeError(f"Failed to run git status: {res.stderr.strip()}")
        return len(res.stdout.strip()) > 0

    def create_snapshot(self, task_id: str) -> str:
        """
        Creates a snapshot of the active workspace and returns the commit hash.
        If the workspace is clean, it simply returns the current HEAD commit hash.
        If dirty (has modifications or untracked files), it stages everything into a 
        temporary index file using the GIT_INDEX_FILE environment variable, writes a tree 
        using git write-tree, commits it referencing the HEAD commit as its parent using 
        git commit-tree, and registers a hidden headless ref for it.
        This leaves the main developer working directory and main .git/index completely unmutated.
        """
        head_commit = self.get_head_commit()
        if not self.is_dirty():
            return head_commit

        # Ensure .git directory exists
        git_dir = self.workspace_path / ".git"
        if not git_dir.exists():
            raise RuntimeError(f".git directory not found in {self.workspace_path}")

        # Path to the temporary index file
        temp_index = git_dir / f"sdd_index_{task_id}"
        
        # Copy the active index to the temporary index if it exists to preserve base index state
        active_index = git_dir / "index"
        if active_index.exists():
            shutil.copy2(active_index, temp_index)

        env = {"GIT_INDEX_FILE": str(temp_index)}

        try:
            # Stage all changes (untracked, modified, deleted) into the temporary index
            add_res = self.run_git(["add", "-A"], env=env)
            if add_res.returncode != 0:
                raise RuntimeError(f"Git staging in temporary index failed: {add_res.stderr.strip()}")

            # Write the tree from the temporary index
            write_tree_res = self.run_git(["write-tree"], env=env)
            if write_tree_res.returncode != 0:
                raise RuntimeError(f"Git write-tree failed: {write_tree_res.stderr.strip()}")
            tree_hash = write_tree_res.stdout.strip()

            # Commit the tree with HEAD as the parent
            commit_msg = f"SDD Headless Snapshot for task {task_id}"
            commit_res = self.run_git([
                "commit-tree", tree_hash,
                "-p", head_commit,
                "-m", commit_msg
            ], env=env)
            if commit_res.returncode != 0:
                raise RuntimeError(f"Git commit-tree failed: {commit_res.stderr.strip()}")
            snapshot_commit = commit_res.stdout.strip()

            # Update/create the hidden headless tracking ref
            ref_name = f"refs/sdd/snapshots/{task_id}"
            ref_res = self.run_git(["update-ref", ref_name, snapshot_commit])
            if ref_res.returncode != 0:
                raise RuntimeError(f"Failed to update ref {ref_name}: {ref_res.stderr.strip()}")

            return snapshot_commit

        finally:
            # Clean up the temporary index file
            if temp_index.exists():
                try:
                    os.remove(temp_index)
                except Exception:
                    pass

    def add_worktree(self, worktree_path: str, commit_hash: str):
        """Spawns a temporary detached Git worktree from the specified commit hash."""
        path = Path(worktree_path).resolve()
        if path.exists():
            raise RuntimeError(f"Worktree path already exists: {path}")

        res = self.run_git(["worktree", "add", "--detach", str(path), commit_hash])
        if res.returncode != 0:
            raise RuntimeError(f"Failed to add git worktree at {path}: {res.stderr.strip()}")

    def remove_worktree(self, worktree_path: str):
        """Forces removal of the temporary Git worktree and prunes references."""
        path = Path(worktree_path).resolve()
        if not path.exists():
            return

        res = self.run_git(["worktree", "remove", "--force", str(path)])
        if res.returncode != 0:
            raise RuntimeError(f"Failed to remove git worktree at {path}: {res.stderr.strip()}")
        
        # Prune worktree refs
        self.run_git(["worktree", "prune"])

