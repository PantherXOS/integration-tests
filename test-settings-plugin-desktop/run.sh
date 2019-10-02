#!/bin/sh

mkdir -p logs
px-settings-service -d > logs/settings.log  2>&1 &
sleep 1

bats .

for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
