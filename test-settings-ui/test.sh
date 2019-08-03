#!/bin/sh
echo "-------------------------------------------------"
echo "         px-settings-ui initial test"
echo "            * Accounts section"
echo "-------------------------------------------------"

echo " + Package installation:"
guix package -i px-accounts-service px-accounts-service-plugin-etherscan px-accounts-service-plugin-cryptocurrency px-accounts-service-plugin-bitcoin px-settings-service px-settings-service-plugin-accounts px-settings-ui > pkg-installation.log 2>&1
if [ $? -eq 0 ]; then
	echo "   - px-accounts-service                       : installed"
	echo "   - px-accounts-service-plugin-etherscan      : installed"
	echo "   - px-accounts-service-plugin-cryptocurrency : installed"
	echo "   - px-accounts-service-plugin-bitcoin        : installed"
	echo "   - px-settings-service                       : installed"
	echo "   - px-settings-service-plugin-accounts       : installed"
	echo "   - px-settings-ui                            : installed"
else
	echo "   - ! error in package installation (more information in pkg-installation.log)"
	exit -1
fi

echo " + Copying some sample accounts."
mkdir ~/.userdata/accounts/ -p
cp *.yaml ~/.userdata/accounts/

echo " + Running px-accounts-service."
px-accounts-service -d > accounts.log 2>&1 &
sleep 10

echo " + Running px-settings-service."
px-settings-service  > settings.log 2>&1 &
sleep 2

echo " + Running px-settings-ui."
px-settings-ui -d > settings-ui.log 2>&1

