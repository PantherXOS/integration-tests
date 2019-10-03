@test "Getting All Display Settings" {
    run px-settings-service-test getModuleSections display
    [ $status -eq 0 ]
}

@test "Write Display Settings - Virtual-1" {
    run px-settings-service-test addToSection display Virtual-1 display-Virtual-1.yaml
    [ $status -eq 0 ]
}

@test "Apply Display Settings" {
    run px-settings-service-test apply display
    [ $status -eq 0 ]
}

@test "Read Display Settings - Virtual-1" {
    run px-settings-service-test getModuleSection display Virtual-1
    run diff current-display-Virtual-1.yaml display-Virtual-1.yaml
    [ $status -eq 0 ]
}

@test "Write Invalid Display Settings" {
    run px-settings-service-test addToSection display Virtual-1 invalid-display-Virtual-1.yaml
    [ $status -eq 255 ]
}
