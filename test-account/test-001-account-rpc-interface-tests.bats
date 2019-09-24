

act1_title="mytest"
act2_title="mytest_modified"
act1=$(cat << EOF
---
account:
  title: "$act1_title"
  provider: ""
  active: true
  settings:
    {}
  services:
    - python-test:
        k1: v1
        k2: v2
...
EOF
)
act2=$(cat << EOF
---
account:
  title: "$act2_title"
  provider: ""
  active: true
  settings:
    {}
  services:
    - python-test:
        k1: v1
        k2: v2
...
EOF
)


@test "Create Account" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Edit Account Title" {
    if [ -e "$HOME/.userdata/accounts/$act1_title.yaml" ]; then
        run rm "$HOME/.userdata/accounts/$act1_title.yaml";
        [ "$status" -eq 0 ]
    fi
    if [ -e "$HOME/.userdata/accounts/$act2_title.yaml" ]; then
        run rm "$HOME/.userdata/accounts/$act2_title.yaml";
        [ "$status" -eq 0 ]
    fi

    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "edit" "$act1_title" "$act2"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "get" "$act2_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    title_found=$(echo "$output" | grep "title = \"$act2_title\"" | wc -l)
    [ $title_found -gt 0 ]
}

@test "Remove Account" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "delete" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "List of Accounts" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "list"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}



@test "Get Account" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "get" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    title_found=$(echo "$output" | grep "title = \"$act1_title\"" | wc -l)
    [ $title_found -gt 0 ]
}



@test "Set Status" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    
    run python3 ./account_helper.py "set_status" "$act1_title" "online"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}



@test "Get Status" {
    run python3 ./account_helper.py "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    
    run python3 ./account_helper.py "set_status" "$act1_title" "online"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ./account_helper.py "get_status" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    [ "$output" == "online" ]
}
