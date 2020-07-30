HELPER_SCRIPT='../common/account_helper.py'
load common

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

function setup() {
    cleanup_account "$act1_title.yaml"
    cleanup_account "$act2_title.yaml"
}

@test "Create Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Edit Account Title" {

    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "edit" "$act1_title" "$act2"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "get" "$act2_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    title_found=$(echo "$output" | grep "title = \"$act2_title\"" | wc -l)
    [ $title_found -gt 0 ]
}

@test "Remove Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "delete" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "List of Accounts" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "list"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Get Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "get" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    title_found=$(echo "$output" | grep "title = \"$act1_title\"" | wc -l)
    [ $title_found -gt 0 ]
}

@test "Set Status" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    
    run python3 ${HELPER_SCRIPT} "set_status" "$act1_title" "online"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}

@test "Get Status" {
    run python3 ${HELPER_SCRIPT} "create" "$act1"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    
    run python3 ${HELPER_SCRIPT} "set_status" "$act1_title" "online"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "get_status" "$act1_title"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    [ "$output" == "online" ]
}
