#!/bin/sh

mkdir -p logs
px-accounts-service --debug &> logs/account.log &
px-secret-service -d  &> logs/secret.log &
px-event-service -d  &> logs/event.log &
sleep 2s

python3 create_accounts.py &> logs/create_accounts.log &
sleep 4s
px-data-service  &> logs/data.log &
sleep 2s

bats .


for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-event-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-data-service | awk '{print $2}'); do
    kill $pid;
done