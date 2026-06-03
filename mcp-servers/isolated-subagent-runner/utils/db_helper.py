import time
import subprocess
from typing import Tuple, Dict

class DbHelper:
    def __init__(self, engine: str = "docker"):
        """
        Initializes the database companion orchestrator.
        :param engine: 'docker' or 'podman'
        """
        self.engine = engine

    def run_cmd(self, args: list) -> subprocess.CompletedProcess:
        """Runs container engine commands."""
        return subprocess.run(
            [self.engine] + args,
            capture_output=True,
            text=True
        )

    def create_network(self, network_name: str):
        """Creates the isolated bridge network if it doesn't already exist."""
        res = self.run_cmd(["network", "inspect", network_name])
        if res.returncode != 0:
            self.run_cmd(["network", "create", network_name])

    def remove_network(self, network_name: str):
        """Removes the isolated bridge network."""
        self.run_cmd(["network", "rm", network_name])

    def start_database_service(
        self,
        task_id: str,
        database_type: str,
        network_name: str,
        overrides: Dict[str, str]
    ) -> Tuple[str, Dict[str, str]]:
        """
        Spawns the companion database container attached to the isolated bridge network.
        Returns the container name and connection environment variables.
        """
        if database_type.lower() == "none" or not database_type:
            return "", {}

        # Create isolated bridge network
        self.create_network(network_name)
        db_container = f"sdd-db-{database_type}-{task_id}"

        env_vars = {}
        run_args = [
            "run", "-d",
            "--name", db_container,
            "--network", network_name,
        ]

        if database_type.lower() == "postgres":
            # Start postgres with standard credentials
            run_args += [
                "-e", "POSTGRES_PASSWORD=postgres",
                "-e", "POSTGRES_USER=postgres",
                "-e", "POSTGRES_DB=postgres",
                "postgres:15-alpine"
            ]
            # Set connection environment variables pointing to the container name host
            env_vars["DATABASE_URL"] = f"postgresql://postgres:postgres@{db_container}:5432/postgres"
            env_vars["PGPASSWORD"] = "postgres"

        elif database_type.lower() == "redis":
            run_args += ["redis:alpine"]
            env_vars["REDIS_URL"] = f"redis://{db_container}:6379"

        else:
            raise ValueError(f"Unsupported database service type: {database_type}")

        # Execute container run
        res = self.run_cmd(run_args)
        if res.returncode != 0:
            raise RuntimeError(f"Failed to start database companion: {res.stderr.strip()}")

        # Poll database health/readiness using container internal tools
        ready = self.wait_for_db(db_container, database_type)
        if not ready:
            self.stop_database_service(db_container, network_name)
            raise RuntimeError(f"Database companion service {database_type} failed to become ready in time.")

        # Merge custom database environment overrides (e.g. mapping custom DB strings)
        env_vars.update(overrides)

        return db_container, env_vars

    def wait_for_db(self, container_name: str, database_type: str, timeout: int = 30) -> bool:
        """Polls the database container until it passes internal health/readiness checks."""
        start_time = time.time()
        while time.time() - start_time < timeout:
            if database_type.lower() == "postgres":
                res = self.run_cmd(["exec", container_name, "pg_isready", "-U", "postgres"])
                if res.returncode == 0:
                    return True
            elif database_type.lower() == "redis":
                res = self.run_cmd(["exec", container_name, "redis-cli", "ping"])
                if res.returncode == 0 and "PONG" in res.stdout:
                    return True
            time.sleep(1)
        return False

    def stop_database_service(self, container_name: str, network_name: str):
        """Stops and removes the database container and network."""
        if container_name:
            self.run_cmd(["stop", container_name])
            self.run_cmd(["rm", "-f", container_name])
        if network_name:
            self.remove_network(network_name)
