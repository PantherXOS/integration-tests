

@test "Create Blockio Account" {
    run python3 ./btc-helper.py 'create-api'
    [ true ]
}

@test "Check Blockio Account" {
    run python3 ./btc-helper.py 'check-api'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    res='( account = (
    title = "blockio1",
    provider = "",
    active = true,
    settings = [],
    services = [
      (name = "blockio", params = []) ] ) )'
    [ $status -eq 0 ]
    [ "$output" = "$res" ]
}

@test "Check Invalid API_KEY" {
    run python3 ./btc-helper.py 'check-apikey-api'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}


@test "Create Bitcoin Account" {
    run python3 ./btc-helper.py 'create-btc'

    [ "$output" = '(result = true)' ]
}

@test "Check Invalid Address" {
    run python3 ./btc-helper.py 'check-address-btc'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}


@test "Modify Bitcoin Account" {
    if [ -e '/root/.userdata/accounts/my_btc_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_btc_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./btc-helper.py 'modify-btc'
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_btc_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove Bitcoin Account" {
    run python3 ./btc-helper.py 'remove-btc'
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}
