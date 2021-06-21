act_title="imap_test"
act_host='imap.fastmail.com'
act_username='f.sajadi@pantherx.org'
act_port='993'
act_ssl='True'

act=$(cat << EOF
---
account:
  title: "$act_title"
  provider: ""
  active: true
  settings:
    interval: '5000'
  services:
    - imap:
        host: ${act_host}
        password: '****'
        username: ${act_username}
        port: ${act_port}
        use_ssl: ${act_ssl}
...
EOF
)

@test "Create Account" {
    echo "$act" > account.yaml
    run px-accounts-cli -o create -f account.yaml
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}
