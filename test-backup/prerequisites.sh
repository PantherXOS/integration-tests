#!/bin/sh

mkdir logs		
# package installation
echo " + Package installation:"
guix pull
guix package -i px-org-remote-backup-service> logs/pkg-installation.log 2>&1
if [ $? -eq 0 ]; then
    echo "   - px-org-remote-backup-service : installed"
else
	echo "   - ! error in package installation (more information in logs/pkg-installation.log)"
	exit -1
fi
