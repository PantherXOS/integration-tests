#!/bin/sh

mkdir -p logs
px-secret-service -d &> logs/secret.log &
sleep 2s

bats .

for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
