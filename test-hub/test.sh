kill_service ()
{
	for pid in $(ps aux | grep -v grep | grep px-hub-service | awk '{print $2}'); do
		kill $pid;
		return 0
	done
	return 1
}

serivce_is_avail ()
{
	for pid in $(ps aux | grep -v grep | grep px-hub-service | awk '{print $2}'); do
		return 0
	done
	return 1
}
result=0
rm plugins -rf
mkdir plugins
kill_service
if [ "$1" = "dry_run" ]; then
	px-hub-service > logs/dry_run-hub.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "run_valid_cpp_plugin" ]; then
	cp _plugins/valid_plugins.yaml plugins/
	px-hub-service > logs/run_valid_cpp_plugin-hub.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "invalid_plugin" ]; then
    cp _plugins/invalid_plugin.yaml plugins/
	px-hub-service > logs/invalid_cpp_plugins-hub.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "wrong_path_plugin" ]; then
    cp _plugins/wrong_path_plugin.yaml plugins/
	px-hub-service > logs/wrong_path_plugin-hub.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "check_rpc_connection" ]; then
	px-hub-service > logs/check_rpc_connection-settings.log 2>&1 &
	sleep 2
	px-hub-service-cli get_accounts
	result=$?
fi
rm plugins -rf
kill_service
exit $result
