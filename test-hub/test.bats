@test "Running without any plugin" {
    skip
    run ./test.sh dry_run
    [ $status -eq 0 ]
}

@test "Running with cpp sample plugin" {
    skip
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
    skip
    run ./test.sh check_rpc_connection
    [ $status -eq 0 ]
}

@test "retrive message and account from hub based on account" {    
    run px-hub-service-test refresh test-integration-accounts
    diff test-integration-accounts plugin-cpp-test-sampl-struct.yaml
    [ $status -eq 0 ]
}

