import os
import sys
import platform
import subprocess
from pathlib import Path
from typing import Dict, Any, Tuple

class EnvProfiler:
    def __init__(self, workspace_path: str):
        self.workspace_path = Path(workspace_path).resolve()

    def check_container_engine(self) -> str:
        """Checks if Docker or Podman is available and running."""
        # Try docker first
        try:
            res = subprocess.run(["docker", "info"], capture_output=True, text=True, timeout=5)
            if res.returncode == 0:
                return "docker"
        except Exception:
            pass

        # Try podman
        try:
            res = subprocess.run(["podman", "info"], capture_output=True, text=True, timeout=5)
            if res.returncode == 0:
                return "podman"
        except Exception:
            pass

        return "none"

    def get_os_virtualization(self) -> Tuple[str, bool]:
        """Detects the host OS and whether it runs with a virtualized storage layer (macOS/Windows hypervisors)."""
        system = platform.system().lower()
        # On macOS (darwin) and Windows, Docker/Podman run inside a virtual machine hypervisor layer
        # which introduces severe volume IO latency. On Linux, they run natively.
        is_virtualized = system in ["darwin", "windows"]
        return system, is_virtualized

    def determine_volume_strategy(self, is_virtualized: bool) -> str:
        """Determines volume strategy: 'named_volume' (caches inside hypervisor) or 'bind_mount' (native Linux)."""
        if is_virtualized:
            return "named_volume"
        return "bind_mount"

    def check_git_locks(self) -> bool:
        """Checks if there are active physical lock files in the .git repository directory."""
        git_dir = self.workspace_path / ".git"
        if not git_dir.exists():
            # If workspace_path itself is not a git repo, check parent directories (climbing up)
            for parent in self.workspace_path.parents:
                if (parent / ".git").exists():
                    git_dir = parent / ".git"
                    break
        
        if not git_dir.exists():
            return False

        # Common git lock locations
        lock_files = [
            git_dir / "index.lock",
            git_dir / "refs" / "heads" / "index.lock",
            git_dir / "config.lock",
            git_dir / "HEAD.lock",
        ]
        
        for lock in lock_files:
            if lock.exists():
                return True
        return False

    def profile(self) -> Dict[str, Any]:
        """Profiles the system environment, checking locks and resources, and returns diagnostic results."""
        engine = self.check_container_engine()
        system, is_virtualized = self.get_os_virtualization()
        vol_strategy = self.determine_volume_strategy(is_virtualized)
        has_locks = self.check_git_locks()

        # Validate core prerequisites
        ready = engine != "none" and not has_locks
        error_msg = None
        if engine == "none":
            error_msg = "No running container engine (Docker/Podman) was found. Please ensure your container daemon is running."
        elif has_locks:
            error_msg = "Active Git lock file detected. Please wait for any pending Git command to complete or resolve locks before execution."

        return {
            "workspace_path": str(self.workspace_path),
            "container_engine": engine,
            "os": system,
            "is_virtualized": is_virtualized,
            "volume_strategy": vol_strategy,
            "has_git_locks": has_locks,
            "ready": ready,
            "error_msg": error_msg
        }
