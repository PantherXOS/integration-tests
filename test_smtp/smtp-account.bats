

@test "Create SMTP Account" {
    run python3 ./smtp-helper.py 'create-smtp'

    [ "$output" = '(result = true)' ]
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
