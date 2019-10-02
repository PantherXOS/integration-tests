#!/bin/sh

mkdir -p logs
px-settings-service -d > logs/settings.log  2>&1 &
sleep 1
# backup from current settings
px-settings-service-test getModuleSection software update > logs/backup.log  2>&1 
mv current-software-update.yaml backup-software-update.yaml

bats .

px-settings-service-test addToSection software update backup-software-update.yaml > logs/restore.log  2>&1 
px-settings-service-test apply software  > logs/apply.log  2>&1 
rm current-*.yaml
for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
