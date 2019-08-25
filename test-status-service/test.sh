#!/bin/sh
echo "-------------------------------------------------"
echo "        px-org-remote-status and backup"
echo "               Integration Test"
echo "-------------------------------------------------"
user=user1
echo " + Running status service:"

px-org-remote-status-service 2>&1 > status-service.log &
cp device.conf /root/.config/
px-org-remote-status-service &
if [ $? -eq 0 ]; then
	echo "   - success"
else
	echo "   - failed"
fi

echo " + Running with valid tarsnap.key"
# copy mockup tarsnap.key
echo "   + Copy tarsnap.key (valid):"
mkdir /home/$user/.config/ -p 
cp valid.key /home/$user/.config/tarsnap.key
echo "test" > /home/$user/test.file
echo "     - /home/$user/.config/ created"
echo "     - copy tarsnap.key done"


# run backup script
echo "   + run px-org-remote-backup-create $user:"
px-org-remote-backup-create.sh $user > create-backup-valid.log 2>&1
if [ $? -eq 0 ]; then
	echo "     - Backup created successfully"
	echo "     - Log to /var/log/backup.log"
else
	echo "     - Backup created failed (more information in create-backup-invalid.log)"
	echo "     - Log to /var/log/backup.log"
fi

sleep 30
for pid in $(ps aux | grep -v grep | grep px-org-remote-status-service | awk '{print $2}'); do
    kill $pid;
done

cat status-service.log | grep "Stat Data sent successfully"
if [ $? -eq 0 ]; then
    exit 0
else
    exit 1
fi
