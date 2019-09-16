

@test "Create Github Account" {
    run python3 ./github-helper.py 'create-github'
    echo "$outpus">&3
    [ "$output" = '(result = true)' ]
}

@test "Check Invalid Username" {
    run python3 ./github-helper.py 'check-invalid-username'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Check Invalid Password" {
    run python3 ./github-helper.py 'check-invalid-password'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}

@test "Modify Github Account" {
    if [ -e '/root/.userdata/accounts/my_github_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_github_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./github-helper.py 'modify-github'
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_github_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove Github Account" {
    run python3 ./github-helper.py 'remove-github'
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}
