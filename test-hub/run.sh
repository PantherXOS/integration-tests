#!/bin/sh

mkdir -p logs
# copy sample account files
cp test-integration-accounts.yaml ~/.userdata/accounts/
cp plugin-cpp-test-sampl-struct.yaml ~/.userdata/hub/

px-accounts-service -d &> logs/accounts.log &
px-events-service -d &> logs/events.log &
sleep 2s

bats .

for pid in $(ps aux | grep -v grep | grep px-accounts-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-hub-service | awk '{print $2}'); do
    kill $pid;
done
for pid in $(ps aux | grep -v grep | grep px-events-service | awk '{print $2}'); do
    kill $pid;
done
rm ~/.userdata/accounts/test-integration-accounts.yaml 
