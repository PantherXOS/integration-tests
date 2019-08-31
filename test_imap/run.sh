#!/bin/sh

mkdir -p logs
px-accounts-service --debug  &> logs/account.log &
px-secret-service -d  &> logs/secret.log &
sleep 2s

bats .

echo '----------------------------------------'
for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done