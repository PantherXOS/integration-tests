#!/bin/sh

rm -rf logs
mkdir -p logs


for pid in $(ps aux | grep -v grep | grep event-module | awk '{print $2}'); do
    echo "killing $pid";
    kill $pid;
done

px-accounts-service --debug 2>&1 > logs/account.log &
px-secret-service -d 2>&1 > logs/secret.log &
px-events-service -d 2>&1 > logs/event.log &
sleep 2s

bats .

for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-events-service | awk '{print $2}'); do
    kill $pid;
done
