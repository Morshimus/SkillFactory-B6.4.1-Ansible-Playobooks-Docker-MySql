#!/bin/bash
DOCKER_DIR=/mnt/wsl/shared-docker && \
sudo mkdir -pm o=,ug=rwx "$DOCKER_DIR" && \
sudo chgrp docker "$DOCKER_DIR" 

