#!/bin/sh

rm -rf logs
mkdir -p logs
px-accounts-service --debug 2>&1 > logs/account.log &
px-secret-service -d 2>&1 > logs/secret.log &
sleep 2s

bats .

echo '----------------------------------------'
for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
echo '----------------------------------------'
# cat logs/account.log
echo '----------------------------------------'