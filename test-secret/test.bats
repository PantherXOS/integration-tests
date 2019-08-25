@test "Adding Parameters to Secret Service" {
    run px-secret-service-test addParam wallet1 app1 param1 value1
    [ $status -eq 0 ]
}

@test "Editing Invalid Parameter" {
    run px-secret-service-test editParam wallet1 app1 param10 value1
    [ $status -eq 255 ]
}

@test "Editing Parameter from Invalid Application" {
    run px-secret-service-test editParam wallet1 app10 param1 value1
    [ $status -eq 255 ]
}

@test "Editing Parameter from Invalid Wallet" {
    run px-secret-service-test editParam wallet10 app1 param1 value1
    [ $status -eq 255 ]
}

@test "Editting the Parameter1 in Secret Service" {
    run px-secret-service-test editParam wallet1 app1 param1 value1
    [ $status -eq 0 ]
}

@test "Deleting the Parameter1 from Secret Service" {
    run px-secret-service-test delParam wallet1 app1 param1
    [ $status -eq 0 ]
}

@test "Gettings the parameters of Invalid Application" {
    run px-secret-service-test getParams wallet1 app10
    [ $status -eq 134 ]
}

@test "Gettings the parameters of Invalid Wallet" {
    run px-secret-service-test getParams wallet10 app1 
    [ $status -eq 134 ]
}

@test "Getting the Parameters from Secret Service" {
    run px-secret-service-test getParams wallet1 app1
    [ $status -eq 0 ]
}

@test "Getting Invalid Parameter" {
    run px-secret-service-test getParam wallet1 app1 param10
    [ $status -eq 134 ]
}

@test "Getting Parameter from Invalid Application" {
    run px-secret-service-test getParam wallet1 app10 param1
    [ $status -eq 134 ]
}

@test "Getting Parameter from Invalid Wallet" {
    run px-secret-service-test getParam wallet10 app1 param1
    [ $status -eq 134 ]
}

@test "Getting the Parameter1 from Secret Service" {
    run px-secret-service-test getParam wallet1 app1 param1
    [ $status -eq 0 ]
}

@test "Getting Applications of Invalid Wallet" {
    run px-secret-service-test getApplications wallet10 app1
    [ $status -eq 255 ]
}

@test "Getting the Applications from Secret Service" {
    run px-secret-service-test getApplications wallet1
    [ $status -eq 0 ]
}

@test "Getting the Wallets from Secret Service" {
    run px-secret-service-test getWallets
    [ $status -eq 0 ]
}

@test "Deleting Invalid Application" {
	run px-secret-service-test delApplication wallet1 app10
    [ $status -eq 255 ]
}

@test "Deleting Application from Invalid Wallet" {
    run px-secret-service-test delApplication wallet10 app1
	[ $status -eq 255 ]
}

@test "Deleting the application from Secret Service" {
    run px-secret-service-test delApplication wallet1 app1
    [ $status -eq 0 ]
}

@test "Deleting Invalid Wallet" {
    run px-secret-service-test delWallet wallet10
    [ $status -eq 255 ]
}

@test "Deleting the wallet from Secret Service" {
    run px-secret-service-test delWallet wallet1
    [ $status -eq 0 ]
}

@test "Deleting Invalid Parameter" {
    run px-secret-service-test delParam wallet1 app1 param10
    [ $status -eq 255 ]
}

@test "Deleting Parameter from Invalid Application" {
    run px-secret-service-test delParam wallet1 app10 param1
    [ $status -eq 255 ]
}

@test "Deleting Parameter from Invalid Wallet" {
    run px-secret-service-test delParam wallet10 app1 param1
    [ $status -eq 255 ]
}
