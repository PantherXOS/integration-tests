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

echo " + Package installation:"
guix package -i px-lib-rw-guix-config px-setup-assistant > pkg-installation.log 2>&1
if [ $? -eq 0 ]; then
    echo "   - px-lib-rw-guix-config : installed"
    echo "   - px-setup-assistant    : installed"
else
	echo "   - ! error in package installation (more information in pkg-installation.log)"
	exit -1
fi

echo " + Running px-setup-assistant:"
echo "   - Add user as an argument"
px-setup-assistant -p desktop -u $user -g $group -t $tz -l $locale -c "$comment" -H $hostname -d debug -r true > setup-1.log 2>&1
if [ $? -eq 0 ]; then
	if [ -f "new-config.scm" ]; then
		if [ -d /home/$user ]; then
			echo "      * user (name:$user, group:$group, comment:$comment, $tz, hostname:$hostname, locale:$locale)"
			echo "      * new-config.scm generated"
			echo "      * guix reconfiguration done successfully"
			echo "   - Done successfully"
		else
			echo "     /home/$user not available (more information in setup-1.log)"
		fi
	else
		echo "     new-config.scm not available (more information in setup-1.log)"
	fi
else
	echo "     Error in px-setup-assistant running (more information in setup-1.log)"
fi