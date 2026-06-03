import os
import socket
import select
import threading
from pathlib import Path
from typing import Optional

class SocketProxy:
    def __init__(self, host_socket_path: str, target_socket_path: str):
        """
        Initializes the bi-directional Unix domain socket proxy.
        :param host_socket_path: Path on the host where the proxy will listen.
        :param target_socket_path: Path of the target socket (e.g. host's SSH_AUTH_SOCK) to forward to.
        """
        self.host_socket_path = Path(host_socket_path).resolve()
        self.target_socket_path = Path(target_socket_path).resolve()
        self.is_running = False
        self._server_socket: Optional[socket.socket] = None
        self._thread: Optional[threading.Thread] = None

    def start(self):
        """Starts the proxy server in a background thread."""
        if not self.target_socket_path.exists():
            # If target socket doesn't exist, we cannot proxy to it
            return

        # Create host directory with strict chmod 700 permissions
        self.host_socket_path.parent.mkdir(parents=True, exist_ok=True)
        os.chmod(str(self.host_socket_path.parent), 0o700)

        if self.host_socket_path.exists():
            self.host_socket_path.unlink()

        self._server_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._server_socket.bind(str(self.host_socket_path))
        self._server_socket.listen(10)
        self._server_socket.settimeout(1.0)

        self.is_running = True
        self._thread = threading.Thread(target=self._listen_loop, daemon=True)
        self._thread.start()

    def stop(self):
        """Stops the proxy server and cleans up socket files and folders."""
        self.is_running = False
        if self._server_socket:
            try:
                self._server_socket.close()
            except Exception:
                pass
        if self._thread:
            self._thread.join(timeout=2.0)
        if self.host_socket_path.exists():
            try:
                self.host_socket_path.unlink()
            except Exception:
                pass
        try:
            self.host_socket_path.parent.rmdir()
        except Exception:
            pass

    def _listen_loop(self):
        while self.is_running:
            try:
                client_sock, _ = self._server_socket.accept()
                threading.Thread(target=self._handle_client, args=(client_sock,), daemon=True).start()
            except socket.timeout:
                continue
            except Exception:
                break

    def _handle_client(self, client_sock: socket.socket):
        try:
            target_sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            target_sock.connect(str(self.target_socket_path))
        except Exception:
            try:
                client_sock.close()
            except Exception:
                pass
            return

        # Bi-directional forwarding between client socket (container side) and target socket (host side)
        sockets = [client_sock, target_sock]
        try:
            while self.is_running:
                readable, _, _ = select.select(sockets, [], [], 1.0)
                if not readable:
                    continue

                for s in readable:
                    data = s.recv(4096)
                    if not data:
                        raise ConnectionError()
                    
                    other_sock = target_sock if s is client_sock else client_sock
                    other_sock.sendall(data)
        except Exception:
            pass
        finally:
            try:
                client_sock.close()
            except Exception:
                pass
            try:
                target_sock.close()
            except Exception:
                pass
