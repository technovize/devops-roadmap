#!/usr/bin/env bash
set -euo pipefail

# Ubuntu/Debian — official installation script
curl -fsSL https://get.docker.com | bash

# Add your user to the docker group (avoid using sudo for every command)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker version
docker run hello-world
