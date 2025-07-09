#!/bin/bash

# TODO: entr is not installed. think of other solutions!
#       after that, write good documentation (see neovim run.sh)

# ./mongo.sh <query_file> [<url>]

QUERY_FILE="$1"
DB_URL="$2"

if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 1 ]]; then
    if [[ -z "$(podman port mongo-server)" && -n "$DB_URL" ]] || [[ -n "$(podman port mongo-server)" && -z "$DB_URL" ]]; then
        echo 'stopping mongo server...'
        podman stop mongo-server >/dev/null
    fi
fi

if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    if [[ -z "$DB_URL" ]]; then
        echo "launching mongo server..."
        podman run --rm -d -v mongodb_data:/data/db --name mongo-server --network none docker.io/library/mongo:latest >/dev/null
    else
        echo "launching mongo server [WARNING: exposing port on localhost]..."
        podman run --rm -d -v mongodb_data:/data/db --name mongo-server -p27017:27017 docker.io/library/mongo:latest >/dev/null
    fi
    sleep 1
fi

[[ -z "$QUERY_FILE" ]] && exit 0
! [[ -f "$QUERY_FILE" ]] && echo "not a file: $1" && exit 1

echo "$QUERY_FILE" | entr sh -c "clear && podman exec -t mongo-server mongosh $DB_URL --quiet --eval \"\$(cat $QUERY_FILE)\""
