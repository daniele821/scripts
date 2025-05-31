#!/bin/bash

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"

podman build -t custom-sqlplus -f "${SCRIPT_DIR}/Dockerfile" "${SCRIPT_DIR}" 
