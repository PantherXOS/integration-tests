

@test "Create Etherscan Account" {
    run python3 ./eth-helper.py 'create-api'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}

@test "Check Etherscan Account" {
    run python3 ./eth-helper.py 'check-api'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    res='( account = (
    title = "etherscan1",
    provider = "",
    active = true,
    settings = [],
    services = [
      (name = "etherscan", params = []) ] ) )'
    [ $status -eq 0 ]
    [ "$output" = "$res" ]
}

@test "Create Ethereum Account" {
    run python3 ./eth-helper.py 'create-eth'

    [ "$output" = '(result = true)' ]
}

@test "Check Invalid Address" {
    run python3 ./eth-helper.py 'check-address-eth'
    found=$(echo "$output" | grep 'debug: err = Account verification failed"' | wc -l)
    [ $found -eq 0 ]
}


@test "Modify Ethereum Account" {
    if [ -e '/root/.userdata/accounts/my_eth_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_eth_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./eth-helper.py 'modify-eth'
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_eth_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove Ethereum Account" {
    run python3 ./eth-helper.py 'remove-eth'
    [ $status -eq 0 ]
    [ "$output" = '(result = true)' ]
}
