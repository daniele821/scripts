#!/bin/bash

QUERY_FILE="$1"
DB_URL="$2"

! [[ -f "$QUERY_FILE" ]] && echo "not a file: $1" && exit 1
[[ -z "$DB_URL" ]] && echo "missing database url" && exit 1

if [[ "$(podman ps --filter "name=oracle-client" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
    echo "container 'oracle-client' is not running"
    exit 1
fi

echo "$QUERY_FILE" | entr bash -c "clear; podman cp $QUERY_FILE oracle-client:/tmp/query.sql && podman exec -t oracle-client bash -c 'echo \"\$(cat /tmp/query.sql)\" | sqlplus -s ${DB_URL}'"
