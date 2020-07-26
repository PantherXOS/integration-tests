#!/usr/bin/env bash

REMOTE_URL=root@127.0.0.1
REMOTE_PORT=2222
REMOTE_PATH="/root/projects/integration-tests"

ssh ${REMOTE_URL} -p ${REMOTE_PORT} "mkdir -p ${REMOTE_PATH}"
rsync -av -e "ssh -p ${REMOTE_PORT}" --exclude ".git" "." "${REMOTE_URL}:${REMOTE_PATH}"
echo "----------------------------------------"
CMD="cd ${REMOTE_PATH};
     cd $(dirname $1);
     guix environment -m manifest.scm  -- sh $(basename $1);
     "
ssh ${REMOTE_URL} -p ${REMOTE_PORT} ${CMD};
