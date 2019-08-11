

@test "Create backup with valid tarsnap key" {
    run ./test-validkey.sh
    [ $status -eq 0 ]
}

@test "Create backup with invalid tarsnap key" {
    run ./test-invalidkey.sh
    [ $status -eq 0 ]
}