#!/bin/bash

# Neovim: ./run.sh
#
# DESCRIPTION:
#   Create a neovim dev environment image (if missing), and then runs a
#   container, mount the current directory.

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
