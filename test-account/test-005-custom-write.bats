HELPER_SCRIPT='../common/account_helper.py'
load common

act_title="custom_account"
act_k1="foo"
act_v1="bar"
act=$(cat << EOF
---
account:
  title: "$act_title"
  provider: ""
  active: true
  settings:
    {}
  services:
    - cpp-custom:
       $act_k1: $act_v1
...
EOF
   )

function setup() {
    cleanup_account "$act_title.yaml"
}

@test "Add custom Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]

    run python3 ${HELPER_SCRIPT} "get" "$act_title"
    title_found=$(echo "$output" | grep ${act_title} | wc -l)
    if [ $status -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $title_found -gt 0 ]

    data_found=$(echo "$output" | grep ${act_k1} | grep ${act_v1} | wc -l)
    [ $data_found -gt 0 ]
}
