
@test "Create Python Test Account" { 
    run python3 ./test-001-create-eth-helper.py 'create-python-test'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ "$output" == "sample warning" ] 
    [ $status -eq 0 ]
}

@test "Create Etherscan Account" {
    run python3 ./test-001-create-eth-helper.py 'create-api'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Check Etherscan Account" {
    run python3 ./test-001-create-eth-helper.py 'check-api'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Create Ethereum Account" {
    run python3 ./test-001-create-eth-helper.py 'create-eth'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Modify Ethereum Account" {
    if [ -e '/root/.userdata/accounts/my_eth_test.yaml' ]; then
        run rm '/root/.userdata/accounts/my_eth_test.yaml'
        [ "$status" -eq 0 ]
    fi
    run python3 ./test-001-create-eth-helper.py 'modify-eth'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]    
    found=$(echo "$output" | grep 'title = "my_eth_test"' | wc -l)
    [ $found -gt 0 ]
}

@test "Remove Ethereum Account" {
    run python3 ./test-001-create-eth-helper.py 'remove-eth'
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}
