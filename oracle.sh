#!/bin/bash

# ./oracle.sh <query_file> <url>

QUERY_FILE="$1"
DB_URL="$2"

! [[ -f "$QUERY_FILE" ]] && echo "not a file: $1" && exit 1
[[ -z "$DB_URL" ]] && echo "missing database url" && exit 1

if [[ "$(podman ps --filter "name=oracle-client" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    if ! podman images --format "{{.Repository}}" | grep -qx localhost/custom-sqlplus; then
        echo "building custom image for oracle connections..."
        "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/images/oracle-client/build.sh"
    fi
    echo "launching oracle client container..."
    podman run --rm -d --name oracle-client localhost/custom-sqlplus sleep infinity >/dev/null
    sleep 1
fi

echo "$QUERY_FILE" | entr bash -c "clear; podman cp $QUERY_FILE oracle-client:/tmp/query.sql && podman exec -t oracle-client bash -c 'echo \"\$(cat /tmp/query.sql)\" | sqlplus -s ${DB_URL}'"
