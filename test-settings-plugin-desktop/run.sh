#!/bin/sh

mkdir -p logs
px-settings-service -d > logs/settings.log  2>&1 &
sleep 1
# backup from current settings
px-settings-service-test getModuleSection desktop background > logs/backup-background.log  2>&1 
px-settings-service-test getModuleSection desktop icons > logs/backup-icons.log  2>&1 
mv current-desktop-background.yaml backup-desktop-background.yaml
mv current-desktop-icons.yaml backup-desktop-icons.yaml

bats .

# restore previous settings
px-settings-service-test addToSection desktop background backup-desktop-background.yaml > logs/restore-background.log  2>&1 
px-settings-service-test addToSection desktop icons backup-desktop-icons.yaml > logs/restore-icons.log  2>&1 
px-settings-service-test apply desktop  > logs/apply.log  2>&1 
rm current-*.yaml backup-*.yaml

for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
    kill $pid;
done
