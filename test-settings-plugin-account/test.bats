@test "Getting All Accounts Settings" {
    run px-settings-service-test getModuleSections accounts
    [ $status -eq 0 ]
}

@test "Getting Available Accounts" {
    run px-settings-service-test getModuleSection accounts accounts
    [ $status -eq 0 ]
}

@test "Getting Registered Account Plugin" {
    run px-settings-service-test getModuleSection accounts templates
    [ $status -eq 0 ]
}

@test "Add Etherscan Account" {
    run px-settings-service-test addToSection accounts templates ether-account.yaml
    [ $status -eq 0 ]
}

@test "Edit Account" {
    skip "px-settings-ui (issue#24)"
    run px-settings-service-test 
    [ $status -eq 0 ]
}

@test "Remove Account" {
    run px-settings-service-test removeFromSection accounts integration-ether-test 0 
    [ $status -eq 0 ]
}

@test "Add Invalid Blockio Account" {
    skip "px-settings-service-plugin-accounts (issue#15)"
    run px-settings-service-test addToSection accounts templates btc-invalid-account.yaml
    [ $status -eq 0 ]
}

# @test "Remove Invalid Account - px-settings-service-plugin-accounts (issue#15)" {
@test "Remove Invalid Account" {
    skip "px-settings-service-plugin-accounts (issue#15)"
    run px-settings-service-test removeFromSection accounts btc-invalid-account 0 
    [ $status -eq 0 ]
}