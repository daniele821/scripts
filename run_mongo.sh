#!/bin/bash

# to start the docker container with the server:
# 1) podman run --rm -d -v mongodb_data:/data/db --name mongo-server --network none docker.io/library/mongo:latest
# 2) podman run --rm -d -v mongodb_data:/data/db --name mongo-server -p27017:27017 docker.io/library/mongo:latest 
# note: 1) completely isolates the server, 2) if other local apps needs to access the server

QUERY_FILE="$1"
DB_URL="$2"

! [[ -f "$QUERY_FILE" ]] && echo "not a file: $1" && exit 1

if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    echo "container 'mongo-server' is not running"
    exit 1
fi

echo "$QUERY_FILE" | entr sh -c "clear && podman exec -t mongo-server mongosh $DB_URL --quiet --eval \"\$(cat $QUERY_FILE)\""

