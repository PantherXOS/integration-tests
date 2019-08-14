#!/bin/sh
echo "-------------------------------------------------"
echo "        px-org-remote-backup-create test"
echo "-------------------------------------------------"
user=panther
mkdir logs
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
px-org-remote-backup-create.sh $user > logs/create-backup-valid.log 2>&1
if [ $? -eq 0 ]; then
	rm /home/$user/test.file
	echo "     - Backup created successfully"
	echo "     - Log to /var/log/backup.log"
	exit 0
else
	rm /home/$user/test.file
	echo "     - Backup created failed (more information in logs/create-backup-valid.log)"
	echo "     - Log to /var/log/backup.log"
	exit -1
fi
