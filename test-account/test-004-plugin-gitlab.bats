HELPER_SCRIPT='../common/account_helper.py'
load common

act_title="gitlab_test"
act_host='https://git.pantherx.org'
act_username='r.majd'
act=$(cat << EOF
---
account:
  title: "$act_title"
  provider: ""
  active: true
  settings:
    interval: '5000'
  services:
    - gitlab:
        host: ${act_host}
        token: '123'
        username: ${act_username}
...
EOF
)

function setup() {
    cleanup_account "$act_title.yaml"
}

@test "Plugin Gitlab: Create Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}


@test "Plugin Gitlab: Get Account Details" {
    run python3 ${HELPER_SCRIPT} "create" "$act"
    run python3 ${HELPER_SCRIPT} "get" "$act_title"
    title_found=$(echo "$output" | grep ${act_title} | wc -l)
    [ $title_found -gt 0 ]
    host_found=$(echo "$output" | grep ${act_host} | wc -l)
    [ $host_found -gt 0 ]
    username_found=$(echo "$output" | grep ${act_username} | wc -l)
    [ $username_found -gt 0 ]
}
