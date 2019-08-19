

@test "Create SMTP Account" {
    run python3 ./smtp-helper.py 'create-smtp'

    [ "$output" = '(result = true)' ]
}

@test "Check Invalid Host" {
    run python3 ./smtp-helper.py 'check-invalid-host'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Check Invalid Username" {
    run python3 ./smtp-helper.py 'check-invalid-username'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Check Invalid Password" {
    run python3 ./smtp-helper.py 'check-invalid-password'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}


@test "Modify SMTP Account" {
    if [ -e '/root/.userdata/accounts/my_smtp_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_smtp_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./smtp-helper.py 'modify-smtp'
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_smtp_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove SMTP Account" {
    run python3 ./smtp-helper.py 'remove-smtp'
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}
