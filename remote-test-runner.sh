#!/usr/bin/env bash

TARGET_PATH="/root/tmp/integration-tests"

## uncomment following line in case of running a fresh test
# ssh root@127.0.0.1 -p 2222 "rm -rf $TARGET_PATH"
ssh root@127.0.0.1 -p 2222 "mkdir -p $TARGET_PATH"

rsync -av -e "ssh -p 2222" --exclude ".git" "." "root@127.0.0.1:$TARGET_PATH"

echo "----------------------------------------"
CMD="cd $TARGET_PATH;
     cd $(dirname $1);
     ls;
     chmod +x $(basename $1);
     sh $(basename $1);"

ssh root@127.0.0.1 -p 2222 $CMD;
