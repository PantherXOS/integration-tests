@test "Adding Parameters to Secret Service" {
    run ./test-secret addParam wallet1 app1 param1 value1
    [ $status -eq 0 ]
}

@test "Gettings the parameters of Invalid Application" {
    run ./test-secret getParams wallet1 app10
    [ $status -eq 134 ]
}

@test "Gettings the parameters of Invalid Wallet" {
    run ./test-secret getParams wallet10 app1 
    [ $status -eq 134 ]
}

@test "Getting the Parameters from Secret Service" {
    run ./test-secret getParams wallet1 app1
    [ $status -eq 0 ]
}

@test "Getting Invalid Parameter" {
    run ./test-secret getParam wallet1 app1 param10
    [ $status -eq 0 ]
}

@test "Getting Parameter from Invalid Application" {
    run ./test-secret getParam wallet1 app10 param1
    [ $status -eq 134 ]
}

@test "Getting Parameter from Invalid Wallet" {
    run ./test-secret getParam wallet10 app1 param1
    [ $status -eq 134 ]
}

@test "Getting the Parameter1 from Secret Service" {
    run ./test-secret getParam wallet1 app1 param1
    [ $status -eq 0 ]
}

@test "Getting Applications of Invalid Wallet" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Getting the Applications from Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Getting the Wallets from Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Invalid Application" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Application from Invalid Wallet" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting the application from Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Invalid Wallet" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting the wallet from Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Invalid Parameter" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Parameter from Invalid Application" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting Parameter from Invalid Wallet" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Editing Invalid Parameter" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Editing Parameter from Invalid Application" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Editing Parameter from Invalid Wallet" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Editting the Parameter1 in Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}

@test "Deleting the Parameter1 from Secret Service" {
    run ./test.sh
    [ $status -eq 0 ]
}
