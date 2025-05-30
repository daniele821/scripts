#!/bin/bash

function launch_server() {
    if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 0 ]]; then
        echo "launching the mongo container..." >/dev/tty
        podman run --rm -d -v mongodb_data:/data/db --name mongo-server --network none docker.io/library/mongo:latest
        sleep 1
    fi &>/dev/null
}
function stop_server() {
    if [[ "$(podman ps --filter "name=mongo-server" --format "{{.ID}}" | wc -l)" -eq 1 ]]; then
        echo "stopping the mongo container..." >/dev/tty
        podman stop mongo-server
    fi &>/dev/null
}

case "$1" in
"stop")
    stop_server
    ;;
"start")
    launch_server
    ;;
"restart")
    stop_server
    launch_server
    ;;
"enter")
    launch_server
    podman exec -it mongo-server bash
    ;;
"shell")
    launch_server
    podman exec -it mongo-server mongosh --quiet
    ;;
"help" | "")
    echo "Program to launch mongodb server, and run query file on a tracked file

Usage: ./run_mongo.sh [OPTION]|[QUERY_FILE [DB_URL]]

Options:
    stop                stop the mongo server
    start               start the mongo server
    restart             restart the mongo server
    enter               enter mongo container
    shell               enter mongo shell
    help                print this help message

Otherwise: 
    (1) QUERY_FILE      file with mongo queries which will be run every time it is saved
    (2) [DB_URL]        url for the server to connect to (if empty: connects to local server)
"
    ;;
*)
    QUERY_FILE="$1"
    DB_URL="$2"
    [[ ! -f "$QUERY_FILE" ]] && echo "not a file: $QUERY_FILE" && exit 1
    launch_server
    echo "$QUERY_FILE" | entr sh -c "clear && podman exec -t mongo-server mongosh $DB_URL --quiet --eval \"\$(cat $QUERY_FILE)\""
    ;;
esac
