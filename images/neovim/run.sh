#!/bin/bash

# Neovim: ./run.sh
#
# PARAMETERS: none
#
# STEPS:
# - creates podman image named neovim, if missing
# - runs that image and mounts current directory inside of it

for dep in podman dirname realpath; do
    ! command -v "$dep" &>/dev/null && echo "Missing dependency: $dep" && exit 1
done

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
SCRIPT_DIRNAME="$(basename "$(realpath "$PWD")")"
[ "$SCRIPT_DIRNAME" == "/" ] && SCRIPT_DIRNAME='host'

if ! podman image exists localhost/neovim; then
    podman build -t neovim "$SCRIPT_DIR"
fi

podman run --rm -it --security-opt label=disable -v .:/app/"$SCRIPT_DIRNAME" -w /app/"$SCRIPT_DIRNAME" localhost/neovim
