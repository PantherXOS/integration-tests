@test "Getting All Software Settings" {
    run px-settings-service-test getModuleSections software
    [ $status -eq 0 ]
}

@test "Write Software Settings - update" {
    run px-settings-service-test addToSection software update software-update.yaml
    [ $status -eq 0 ]
}

@test "Apply Software Settings" {
    run px-settings-service-test apply software
    [ $status -eq 0 ]
}

@test "Read Software Settings - update" {
    run px-settings-service-test getModuleSection software update
    run diff current-software-update.yaml software-update.yaml
    [ $status -eq 0 ]
}

@test "Write Invalid Software Settings" {
    skip "Invalid data protection issue"
    run px-settings-service-test addToSection software update invalid-software-update.yaml
    [ $status -eq 255 ]
}
