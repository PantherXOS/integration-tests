act_title="imap_test"
act_host="imap.fastmail.com"
act_username="f.sajadi@pantherx.org"
act_port="993"
act_ssl="true"

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
        host: "$act_host"
        password: 'PLEASE_ENTER_PASWORD'
        username: "$act_username"
        port: "$act_port"
        use_ssl: "$act_ssl"
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

@test "Get Account Details" {
    run px-accounts-cli -o "list"
    account_id=$(echo "$output" | grep $act_title | cut -f 2 -d "(" | cut -f 1 -d"," | cut -f 2 -d "'")
    run px-accounts-cli -o get -i "${account_id}"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
    host_found=$(echo "$output" | grep ${act_host} | wc -l)
    [ $host_found -gt 0 ]
    username_found=$(echo "$output" | grep ${act_username} | wc -l)
    [ $username_found -gt 0 ]
    port_found=$(echo "$output" | grep ${act_port} | wc -l)
    [ $port_found -gt 0 ]
}
 
@test "Delete Account" {
    run px-accounts-cli -o "list"
    account_id=$(echo "$output" | grep $act_title | cut -f 2 -d "(" | cut -f 1 -d"," | cut -f 2 -d "'")
    run px-accounts-cli -o remove -i "${account_id}"
    if [ "$status" -ne 0 ]; then
        echo "$output" >&3;
    fi
    [ $status -eq 0 ]
}
