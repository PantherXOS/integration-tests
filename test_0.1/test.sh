#!/bin/sh


echo " Initial integration test 0.1"
echo "************************************************************************"

echo ""
echo " update Guix package repository:"
echo " *******************************************************"
if ! guix pull && guix package -u; then 
    echo "ERROR: unable to update guix package repository."
    exit -1
fi


echo ""
echo " install required packages "
echo "  *******************************************************"

if ! guix package -i px-setup-assistant px-org-remote-status-service; then
    echo "ERROR: required package installation failed"
    exit -1
fi

echo ""
echo " ************Round 1 ************ "
echo ""





echo ""
echo " ************ Round 2 ************"
echo ""
px-setup-assistant -u fakhri -g users -H fakhriPC -t Asia/Tehran -c Nothing -p desktop;




echo ""
echo " ************ Round 3 ************ "
echo ""
px-setup-assistant -d enable -f config.json
mkdir ~/.userdata     #known bug in px-org-remote-status-service should be resolved in next release
px-org-remote-status-service &
sleep 30s
for PID in $(ps x | grep -v grep | grep 'px-org-remote-status-service' | awk '{print $1}'); do 
    echo " > Terminating px-org-remote-status-service with PID='$PID'"
    kill $PID
done
