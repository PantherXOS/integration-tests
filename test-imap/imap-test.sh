#!/run/current-system/profile/bin/bash

echo "----------------------------------------------------------------------------------"
echo " IMAP Overall Test "
echo "----------------------------------------------------------------------------------"

echo ""
echo " STEP 1. update Guix package repository:"
echo " ---------------------------------------"
if ! guix pull && guix package -u; then 
    echo "ERROR: unable to update guix package repository."
    exit -1
fi

echo ""
echo " STEP 2. install required packages:"
echo " ----------------------------------"
if ! guix package -i python2 python2-pyyaml python2-pycapnp python; then
    echo "ERROR: required package installation failed"
    exit -1
fi
if ! guix package -i px-events-service px-pass-service px-mail-service-imap px-accounts-service px-accounts-service-plugin-protocol-imap px-accounts-service-providers; then
    echo "ERROR: required package installation failed"
    exit -1
fi

echo ""
echo " STEP 3. init password service:"
echo " ------------------------------"
# Variable definitions: 
PASS_APP="px_pass_service"
if [[ -z "${PASS_DIR}" ]]; then 
    PASS_DIR="$HOME/.px_pass" 
fi
if [[ -z "${PASS}" ]]; then 
    PASS="123" 
fi

for PID in $(ps x | grep -v grep | grep $PASS_APP | awk '{print $1}'); do 
    echo " > Terminating old '$PASS_APP' with PID='$PID'"
    kill $PID
done

if [ -d $PASS_DIR ]; then
    rm -rf $PASS_DIR
    echo " > existing password db removed.";
fi

px_pass_service $PASS > pass.log &
echo " >  '$PASS_APP' started with password: '$PASS'"


echo ""
echo " STEP 4. init event service:"
echo " ---------------------------"
EVENT_APP="px-events-service"
for PID in $(ps x | grep -v grep | grep $EVENT_APP | awk '{print $1}'); do 
    echo " > Terminating old '$EVENT_APP' with PID='$PID'"
    kill $PID
done
px-events-service --debug > event.log &
echo " > event service started."


echo ""
echo " STEP 5. init accounts service:"
echo " ------------------------------"
for PID in $(ps x | grep -v grep | grep 'px-accounts-service' | awk '{print $1}'); do 
    echo " > Terminating old 'px-accounts-service' with PID='$PID'"
    kill $PID
done
ACT_DIR="$HOME/.userdata/accounts"
if [ -d $ACT_DIR ]; then
    rm -rf $ACT_DIR
    echo " > existing accounts db removed.";
fi

px-accounts-service --debug --password $PASS > account.log &
echo " > account service started."
sleep 1s

echo ""
echo " STEP 6. start test client:"
echo " ---------"
chmod +x account_rpc_client.py
./account_rpc_client.py account_imap.yaml
sleep 1s


echo ""
echo " STEP 7. run imap sync application:"
echo " ----------------------------------"
for PID in $(ps x | grep -v grep | grep 'px-mail-service-imap' | awk '{print $1}'); do 
    echo " > Terminating old 'px-mail-service-imap' with PID='$PID'"
    kill $PID
done
px-mail-service-imap --pxdebug


# echo ""
# echo " STEP X. :"
# echo " ---------"
