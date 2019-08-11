#!/bin/sh
echo "-------------------------------------------------"
echo "        px-org-remote-backup-create test"
echo "-------------------------------------------------"
user=panther
mkdir logs
echo " + Running with invalid tarsnap.key"
# copy mockup tarsnap.key
echo "   + Copy tarsnap.key (invalid):"
mkdir /home/$user/.config/ -p 
cp invalid.key /home/$user/.config/tarsnap.key
echo "     - /home/$user/.config/ created"
echo "     - copy tarsnap.key done"

# run backup script
echo "   + run px-org-remote-backup-create $user:"
px-org-remote-backup-create.sh $user > logs/create-backup-invalid.log 2>&1
if [ $? -eq 0 ]; then
	echo "     - Backup created successfully"
	echo "     - Log to /var/log/backup.log"
	exit -1
else
	echo "     - Backup created failed (more information in logs/create-backup-invalid.log)"
	echo "     - Log to /var/log/backup.log"
	exit 0
fi
