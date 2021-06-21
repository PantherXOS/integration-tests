#!/bin/sh
# ./run.sh [dont_run_service] [bats_file]
#    [dont_run_service] = true/false
#    [bats_file] = PATH_TO_BAT_FILE.bat

rm -rf logs
mkdir -p logs

dont_run_service=$1
if [ "$dont_run_service" != "true" ]; then
   px-secret-service -d &> logs/secret.log &
   px-events-service -d -t console &> logs/event.log &
   px-accounts-service -d -t console &> logs/account.log &
   sleep 1s
fi
echo "START TESTS"

if [ "$#" -gt 1 ]; then
    bats .
else
    bats "$2"
fi

if [ "$dont_run_service" != "true" ]; then
   echo '----------------------------------------'
   for pid in $(ps aux | grep -v grep | grep -v environment | grep px-accounts-service | awk '{print $2}'); do
       echo " --- KILL ACCOUNTS SERVICE: $pid"
       kill $pid;
   done
   for pid in $(ps aux | grep -v grep | grep px-secret-service | awk '{print $2}'); do
       echo " --- KILL SECRET SERVICE: $pid"
       kill $pid;
   done
   for pid in $(ps aux | grep -v grep | grep px-events-service | awk '{print $2}'); do
       echo " --- KILL EVENTS SERVICE: $pid"
       kill $pid;
   done
   echo '----------------------------------------'
   # cat logs/account.log
   # echo '----------------------------------------'
fi
