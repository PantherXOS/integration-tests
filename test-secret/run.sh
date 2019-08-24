#!/bin/sh

mkdir -p logs
px-secret-service -d 2>&1 > logs/secret.log &
sleep 2s

bats .

echo '----------------------------------------'
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
