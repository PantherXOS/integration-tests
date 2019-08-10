#!/bin/sh
echo "-------------------------------------------------"
echo "            px-setup-assistant test"
echo "-------------------------------------------------"

user=hamzeh
group=users
tz=Asia/Tehran
locale=en_US.utf8
comment="no comment"
hostname=GUIX$user

mkdir logs

echo " + Running px-setup-assistant:"
echo "   - Add user as an argument"
px-setup-assistant -p desktop -u $user -g $group -t $tz -l $locale -c "$comment" -H $hostname -d debug -r true > logs/setup.log 2>&1
if [ $? -eq 0 ]; then
	if [ -f "new-config.scm" ]; then
		guile new-config.scm > logs/compile-config-file.log 2>&1
		rm new-config.scm
		#if [ -d /home/$user ]; then
		if [ $? -eq 0 ]; then
			echo "      * user (name:$user, group:$group, comment:$comment, $tz, hostname:$hostname, locale:$locale)"
			echo "      * new-config.scm generated"
			echo "      * guix reconfiguration done successfully"
			echo "   - Done successfully"
			exit 0
		else
			echo "     Error in new-config.scm (more information in logs/compile-config-file.log)"
			exit -1
		fi
		#else
		#	echo "     /home/$user not available (more information in logs/setup.log)"
		#fi
	else
		echo "     new-config.scm not available (more information in logs/setup.log)"
		exit -1
	fi
else
	echo "     Error in px-setup-assistant running (more information in logs/setup.log)"
	exit -1
fi
