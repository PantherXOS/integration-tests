kill_service ()
{
	for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
		kill $pid;
		return 0
	done
	return 1
}

serivce_is_avail ()
{
	for pid in $(ps aux | grep -v grep | grep px-settings-service | awk '{print $2}'); do
		return 0
	done
	return 1
}

rm plugins -rf
mkdir plugins
kill_service
if [ "$1" = "dry_run" ]; then
	px-settings-service > logs/dry_run-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "run_valid_cpp_plugin" ]; then
	cp _plugins/valid_plugins.yaml plugins/
	px-settings-service > logs/run_valid_cpp_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "invalid_plugin" ]; then
        cp _plugins/invalid_plugin.yaml plugins/
	px-settings-service > logs/invalid_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "wrong_path_plugin" ]; then
        cp _plugins/wrong_path_plugin.yaml plugins/
	px-settings-service > logs/wrong_path_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
elif [ "$1" = "check_rpc_connection" ]; then
	px-settings-service > logs/check_rpc_connection-settings.log 2>&1 &
	sleep 2
	px-settings-service-test getModules
	result=$?
elif [ "$1" = "get_registered_plugin" ]; then
	cp _plugins/valid_plugins.yaml plugins/
	px-settings-service > logs/get_registered_plugin-settings.log 2>&1 &
	sleep 2
	px-settings-service-test getModules | grep cpp-test
	result=$?
fi
rm plugins -rf
kill_service
exit $result
