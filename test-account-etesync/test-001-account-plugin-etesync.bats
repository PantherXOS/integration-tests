HELPER_SCRIPT='../common/account_helper.py'

act_title="etesync_test"
act=$(cat << EOF
---
account:
  title: "$act_title"
  provider: ""
  active: true
  settings:
    {}
  services:
    - etesync:
        email: test_scripting
        login_password: 6AAT7SQsXW
        encryption_password: p@ssw0rd
        etesync_url: https://etesync.pantherx.org
...
EOF
)

@test "Cleanup Old Account" {
    run python3 ${HELPER_SCRIPT} "list"
    [ $status -eq 0 ]
    title_found=$(echo "$output" | grep ${act_title} | wc -l)
    if [ $title_found -gt 0 ]; then
      echo "remove old account details" >&3;
      run python3 ${HELPER_SCRIPT} "delete" "${act_title}"
      [ $status -eq 0 ]
    fi
}

@test "Create Account" {
    run python3 ${HELPER_SCRIPT} "create" "$act"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}


@test "Get Account Details" {
    run python3 ${HELPER_SCRIPT} "get" "$act_title"
    title_found=$(echo "$output" | grep ${act_title} | wc -l)
    [ $title_found -gt 0 ]
    username_found=$(echo "$output" | grep "test_scripting" | wc -l)
    [ $username_found -gt 0 ]
    password_found=$(echo "$output" | grep "password" | wc -l)
    [ $password_found -gt 0 ]
    # echo "$output" >&3;
}