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

rmdir plugins -rf
mkdir plugins
if [ "$1" = "dry_run" ]; then
	px-settings-service > logs/dry_run-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
	rm plugins/valid_plugins.yaml
	kill_service
	exit $?
elif [ "$1" = "run_valid_cpp_plugin" ]; then
	kill_service
	cp _plugins/valid_plugins.yaml plugins/
	px-settings-service > logs/run_valid_cpp_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
	rm plugins/valid_plugins.yaml
	kill_service
	exit $?
elif [ "$1" = "invalid_plugin" ]; then
	kill_service
        cp _plugins/invalid_plugin.yaml plugins/
	px-settings-service > logs/invalid_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
	rm plugins/invalid_plugin.yaml
	kill_service
	exit $?
elif [ "$1" = "wrong_path_plugin" ]; then
	kill_service
        cp _plugins/wrong_path_plugin.yaml plugins/
	px-settings-service > logs/wrong_path_plugin-settings.log 2>&1 &
	sleep 2
	serivce_is_avail
	result=$?
	rm plugins/wrong_path_plugin.yaml
	kill_service
	exit $?
fi
