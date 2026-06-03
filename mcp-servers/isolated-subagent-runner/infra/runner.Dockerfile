# Use a lightweight Debian Bookworm slim base image
FROM debian:bookworm-slim

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install core runtimes, build-essential, git, and python/nodejs
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    openssh-client \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    ca-certificates \
    postgresql-client \
    redis-tools \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root group and user with standard UID/GID 1000
RUN groupadd -g 1000 agent && \
    useradd -u 1000 -g agent -m -s /bin/bash agent

# Setup directories for workspace, user caches, and the Unix domain socket proxy
RUN mkdir -p /workspace /home/agent/.cache /var/run/agent-proxy && \
    chown -R agent:agent /workspace /home/agent /var/run/agent-proxy

# Switch to the non-root user
USER agent
WORKDIR /workspace

# Environment variables for user home, PATH, and caches
ENV HOME=/home/agent
ENV PATH="/home/agent/.local/bin:${PATH}"

# Define mount volumes:
# - /workspace: Mount point for the spawned Git worktree
# - /home/agent/.cache: Persistent named cache volume (virtualization warm-loading)
# - /var/run/agent-proxy: Ephemeral Unix domain socket folder for credential forwarding
VOLUME ["/workspace", "/home/agent/.cache", "/var/run/agent-proxy"]

# Default shell
CMD ["/bin/bash"]
