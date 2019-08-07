

@test "Create/Reconfigure new config.scm" {
    run ./test.sh
    [ $status -eq 0 ]
    [ "${lines[3]}" = '   - Done successfully' ]
}
