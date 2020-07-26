#!/bin/sh

rm -rf logs
mkdir -p logs

px-secret-service -d &> logs/secret.log &
px-events-service -d -t console &> logs/event.log &
px-accounts-service -d -t console &> logs/account.log &
sleep 1s
echo "START TESTS"

if [ "$#" -eq 0 ]; then
    bats .
else
    bats "$1"
fi

echo '----------------------------------------'
for pid in $(ps aux | grep -v grep | grep -v environment | grep px-accounts-service | awk '{print $2}'); do
    echo " --- KILL ACCOUNTS SERVICE: $pid"
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    echo " --- KILL SECRET SERVICE: $pid"
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-events-service | awk '{print $2}'); do
    echo " --- KILL EVENTS SERVICE: $pid"
    kill $pid;
done
echo '----------------------------------------'
# cat logs/account.log
# echo '----------------------------------------'
