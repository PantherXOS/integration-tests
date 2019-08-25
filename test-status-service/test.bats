@test "Submit System Status to px-central" {
    run ./test.sh
    [ $status -eq 0 ]
}
