#!/bin/sh

mkdir -p logs
#px-accounts-service --debug 2>&1 > logs/account.log &
#px-secret-service -d 2>&1 > logs/secret.log &
sleep 2s

bats .

echo '----------------------------------------'
