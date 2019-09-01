#!/bin/sh

mkdir -p logs
px-secret-service -d > logs/secret.log 2>&1 &
px-accounts-service -d > logs/accounts.log 2>&1 &
sleep 5
px-settings-service -d > logs/settings.log  2>&1 &
sleep 2

bats .

for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
