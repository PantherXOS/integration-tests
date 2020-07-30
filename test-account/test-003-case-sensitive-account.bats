HELPER_SCRIPT='../common/account_helper.py'
load common

function setup() {
  cleanup_account "case_sensitive_account.yaml"
}

@test "Account operations for accounts wuth Case Sensitive letters in title" {
  # There is an issue on working accounts with capital letters in title
  # ref2: https://git.pantherx.org/development/applications/px-accounts-service/issues/57
  # ref1: https://git.pantherx.org/development/applications/px-accounts-service/issues/58

  account_title='Case Sensitive Account'
  account_object=$(cat << EOF
---
account:
  title: "$account_title"
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

  run python3 ${HELPER_SCRIPT} 'create' "$account_object"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]

  run python3 ${HELPER_SCRIPT} 'get' "$account_title"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]
  title_found=$(echo "$output" | grep "title = \"$account_title\"" | wc -l)
  [ $title_found -gt 0 ]

  run python3 ${HELPER_SCRIPT} 'set_status' "$account_title" 'online'
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]


  run python3 ${HELPER_SCRIPT} 'get_status' "$account_title"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]
  [ "$output" == "online" ]

}
