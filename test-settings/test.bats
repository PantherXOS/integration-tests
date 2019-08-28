@test "Running without any plugin" {
    run ./test.sh dry_run
    [ $status -eq 0 ]
}

@test "Running with cpp sample plugin" {
    run ./test.sh run_valid_cpp_plugin
    [ $status -eq 0 ]
}

@test "Running with invalid plugin" {
    run ./test.sh invalid_plugin
    [ $status -eq 0 ]
}

@test "Running with wrong path plugin" {
    run ./test.sh wrong_path_plugin
    [ $status -eq 0 ]
}
