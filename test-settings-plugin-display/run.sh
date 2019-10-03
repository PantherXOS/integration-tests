#!/bin/sh

mkdir -p logs
export DISPLAY=:0
px-settings-service -d > logs/settings.log  2>&1 &
sleep 1

# backup from current settings
px-settings-service-test getModuleSection display Virtual-1 > logs/backup.log  2>&1 
mv current-display-Virtual-1.yaml backup-display-Virtual-1.yaml

bats .

# restore previous settings
px-settings-service-test addToSection display Virtual-1 backup-display-Virtual-1.yaml > logs/restore.log  2>&1 
px-settings-service-test apply display  > logs/apply.log  2>&1 
rm current-*.yaml backup-*.yaml


for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
