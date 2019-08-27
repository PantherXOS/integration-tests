#!/bin/sh

mkdir -p logs
px-secret-service -d 2>&1 > logs/secret.log &
px-accounts-service -d 2>&1 > logs/accounts.log &
sleep 5
px-settings-service -d 2>&1 > logs/settings.log &
sleep 2

bats .

echo '----------------------------------------'
for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done