@test "Getting All Desktop Settings" {
    run px-settings-service-test getModuleSections desktop
    [ $status -eq 0 ]
}

@test "Write Desktop Settings - background" {
    run px-settings-service-test addToSection desktop background desktop-background.yaml
    [ $status -eq 0 ]
}

@test "Write Desktop Settings - icons" {
    run px-settings-service-test addToSection desktop icons desktop-icons.yaml
    [ $status -eq 0 ]
}

@test "Apply Desktop Settings" {
    run px-settings-service-test apply desktop
    [ $status -eq 0 ]
}

@test "Read Desktop Settings - background" {
    run px-settings-service-test getModuleSection desktop background
    run diff current-desktop-background.yaml desktop-background.yaml
    [ $status -eq 0 ]
}

@test "Read Desktop Settings - icons" {
    run px-settings-service-test getModuleSection desktop icons
    run diff current-desktop-icons.yaml desktop-icons.yaml
    [ $status -eq 0 ]
}

@test "Write Invalid Desktop Settings" {
    run px-settings-service-test addToSection desktop background invalid-desktop-background.yaml
    [ $status -eq 255 ]
}
