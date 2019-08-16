

@test "Create IMAP Account" {
    run python3 ./imap-helper.py 'create-imap'

    [ "$output" = '(result = true)' ]
}

@test "Modify IMAP Account" {
    if [ -e '/root/.userdata/accounts/my_imap_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_imap_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./imap-helper.py 'modify-imap'
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_imap_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove IMAP Account" {
    run python3 ./imap-helper.py 'remove-imap'
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}
