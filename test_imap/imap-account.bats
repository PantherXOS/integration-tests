

@test "Create IMAP Account" {
    run python3 ./imap-helper.py 'create-imap'
    echo "$outpus">&3
    [ "$output" = '(result = true)' ]
}

@test "Check Invalid Host" {
    run python3 ./imap-helper.py 'check-invalid-host'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Check Invalid Username" {
    run python3 ./imap-helper.py 'check-invalid-username'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Check Invalid Password" {
    run python3 ./imap-helper.py 'check-invalid-password'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
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
