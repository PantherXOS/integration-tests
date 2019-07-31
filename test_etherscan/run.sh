#!/run/current-system/profile/bin/bash

echo "----------------------------------------------------------------------------------"
echo " Etherscan Overall Test "
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
if ! guix package -i python python-pyyaml python-pycapnp; then
    echo "ERROR: required package installation failed"
    exit -1
fi
if ! guix package -i px-events-service px-secret-service px-accounts-service px-accounts-service-plugin-etherscan; then
    echo "ERROR: required package installation failed"
    exit -1
fi

echo ""
echo " STEP 3. init event service:"
echo " ---------------------------"
EVENT_APP="px-events-service"
for PID in $(ps x | grep -v grep | grep $EVENT_APP | awk '{print $1}'); do 
    echo " > Terminating old '$EVENT_APP' with PID='$PID'"
    kill $PID
done
px-events-service --debug > event.log &
echo " > event service started."

echo ""
echo " STEP 4. init secret service:"
echo " ------------------------------"
for PID in $(ps x | grep -v grep | grep 'px-secret-service' | awk '{print $1}'); do 
    echo " > Terminating old 'px-secret-service' with PID='$PID'"
    kill $PID
done
px-secret-service --debug > secret.log &
echo " > secret service started."


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
    echo " > existing accounts removed.";
fi

px-accounts-service --debug > account.log &
echo " > account service started."
sleep 1s

echo ""
echo " STEP 6. start test etherscan:"
echo " ---------"
chmod +x test.py
python3 ./test.py account_etherscan.yaml
sleep 1s
