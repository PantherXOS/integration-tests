HELPER_SCRIPT='../common/account_helper.py'
load common


function setup() {
  cleanup_account "modified_public_test.yaml"
}

@test "Rename Public Account Title" {
  # Renaming an account with public services caused error 
  # in removing protected params, which is not existed
  # ref: https://git.pantherx.org/development/applications/px-accounts-service/issues/47

  initial_title='public_test'
  initial_act=$(cat << EOF
---
account:
  title: "public test"
  provider: ""
  active: true
  settings:
    {}
  services:
    - public-test:
        k1: v1
        k2: v2
...
EOF
)

  run python3 ${HELPER_SCRIPT} 'create' "$initial_act"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]

  run python3 ${HELPER_SCRIPT} 'get' "public_test"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]
  title_found=$(echo "$output" | grep 'title = "public test"' | wc -l)
  [ $title_found -gt 0 ]

  modified_title='modified_public_title'
  modified_act=$(cat << EOF
---
account:
  title: "modified public test"
  provider: ""
  active: true
  settings:
    {}
  services:
    - public-test:
        k1: v1
        k2: v2
...
EOF
)
  run python3 ${HELPER_SCRIPT} 'edit' "$initial_title" "$modified_act"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]
}
