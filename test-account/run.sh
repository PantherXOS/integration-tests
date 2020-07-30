#!/bin/sh

reset_logs() {
    rm -rf logs
    mkdir -p logs
}

start_daemon() {
    echo ">>> START DAEMON: [$1]"
    screen -L -Logfile "logs/$1.log" -dmS $1  $@ 2>&1
    sleep 1
    screen -S $1 -X logfile flush 0
}

stop_daemon() {
    echo ">>> STOP DAEMON: [$1]"
    screen -S $1 -X quit
    # cat "logs/$1.log"
    # echo "----------"
    # echo "----------"

    for pid in $(ps aux | grep -v grep | grep -v environment | grep "$1" | awk '{print $2}'); do
        echo ">>> KILL $pid";
        kill $pid;
    done
}

main() {
    if [ -n "$GUIX_ENVIRONMENT" ]; then
        export PLUGIN_PATH="$GUIX_ENVIRONMENT/etc/px/accounts/plugins/"
    fi
    reset_logs
    start_daemon px-secret-service -d
    start_daemon px-events-service -d -t console
    start_daemon px-accounts-service -d -t console

    if [ $# -eq 0 ]; then
        echo "RUN ALL OF TESTS"
        guix environment --pure -m manifest.scm -- bats .
    else
        echo "RUN TEST: [$1]"
        guix environment --pure -m manifest.scm -- bats "$1"
    fi

    stop_daemon px-accounts-service
    stop_daemon px-events-service
    stop_daemon px-secret-service
}

main $@
