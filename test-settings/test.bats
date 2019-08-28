@test "Running without any plugin" {
    run ./test.sh dry_run
    [ $status -eq 0 ]
}

@test "Running with cpp sample plugin" {
    run ./test.sh run_valid_cpp_plugin
    [ $status -eq 0 ]
}

@test "Running with invalid plugin" {
    skip
    run ./test.sh invalid_plugin
    [ $status -eq 0 ]
}

@test "Running with wrong path plugin" {
    skip
    run ./test.sh wrong_path_plugin
    [ $status -eq 0 ]
}

@test "Running and Checking the RPC communication" {
    run ./test.sh check_rpc_connection
    [ $status -eq 0 ]
}

@test "Running and Getting the List of Plugins by RPC" {
    run ./test.sh get_registered_plugin
    [ $status -eq 0 ]
}
