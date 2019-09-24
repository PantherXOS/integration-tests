
@test "Test Trojita Plugin" {

  if [ -e "$HOME/.userdata/accounts/trojita_test.yaml" ]; then
    run rm "$HOME/.userdata/accounts/trojita_test.yaml"
    [ "$status" -eq 0 ]
  fi

  act=$(cat << EOF
---
account:
  title: "trojita test"
  provider: ""
  active: true
  settings:
    {}
  services:
    - trojita:
       real_name: 'Test Account'
       email_address: 'test2@fastmail.de'
       organisation: 'test org'
       imap_encryption: tls
       imap_user: 'test2@fastmail.de'
       imap_pass: 'h6wgvfd4us38qrm8'
       imap_host: 'imap.fastmail.com'

       smtp_encryption: tls
       smtp_auth: 'true'
       smtp_host: 'smtp.fastmail.com'
       smtp_user: 'test2@fastmail.de'
       smtp_pass: 'h6wgvfd4us38qrm8'
...
EOF
)

  run python3 ./account_helper.py 'create' "$act"
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
    echo "----------------------------------------" >&3;
    cat "logs/account.log" >&3;
    echo "----------------------------------------" >&3;
  fi
  [ $status -eq 0 ]

  run python3 ./account_helper.py 'get' 'trojita_test'
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
    echo "----------------------------------------" >&3;
    cat "logs/account.log" >&3;
    echo "----------------------------------------" >&3;
  fi
  # echo "$output" >&3;
  [[ "$output" == *"real_name"* ]]
  [[ "$output" == *"email_address"* ]]
  [[ "$output" == *"organization"* ]]
  [[ "$output" == *"imap_encryption"* ]]
  [[ "$output" == *"imap_host"* ]]
  [[ "$output" == *"imap_port"* ]]
  [[ "$output" == *"imap_user"* ]]
  [[ "$output" == *"imap_pass"* ]]
  [[ "$output" == *"smtp_encryption"* ]]
  [[ "$output" == *"smtp_auth"* ]]
  [[ "$output" == *"smtp_host"* ]]
  [[ "$output" == *"smtp_port"* ]]
  [[ "$output" == *"smtp_user"* ]]
  [[ "$output" == *"smtp_pass"* ]]
}

