#!/bin/sh


echo " Initial integration test 0.1"
echo "************************************************************************"

echo ""
echo " update Guix package repository:"
echo " *******************************************************"
#if ! guix pull && guix package -u; then 
#    echo "ERROR: unable to update guix package repository."
#    exit -1
#fi


echo ""
echo " install required packages "
echo "  *******************************************************"

#if ! guix package -i px-setup-assistant px-org-remote-status-service; then
#    echo "ERROR: required package installation failed"
#    exit -1
#fi

echo ""
echo " ************Round 1 ************ "
echo ""
login_response=$(curl --request POST \
  --url https://pxcentral-backend.herokuapp.com/login \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data username=root \
  --data password=root
  > /dev/null)
accessToken=$(echo $login_response | cut -f2 -d":" | tr -d } | tr -d '\"' ) 
echo "-H \"authorization: Bearer $accessToken\"" > header
curl --request GET --url https://pxcentral-backend.herokuapp.com/devices --config header
curl --request GET \
  --url https://pxcentral-backend.herokuapp.com/devices/0563e0b8-55f7-4f7b-86f4-b81b2877d4fe/config \
  --config header > config.json





echo ""
echo " ************ Round 2 ************"
echo ""
px-setup-assistant -u fakhri -g users -H fakhriPC -t Asia/Tehran -c Nothing -p desktop > setup-r2.log




echo ""
echo " ************ Round 3 ************ "
echo ""

px-setup-assistant -d enable -f config.json > setup-r3.log
mkdir ~/.userdata     #known bug in px-org-remote-status-service should be resolved in next release
px-org-remote-status-service &
sleep 30s

for PID in $(ps x | grep -v grep | grep 'px-org-remote-status-service' | awk '{print $1}'); do 
    echo " > Terminating px-org-remote-status-service with PID='$PID'"
    kill $PID
done
