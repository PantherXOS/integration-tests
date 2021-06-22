act_title="s3_test"
act_key='IHR8RDGJWCG0JA9255OZ'
act_bucket='backup-internal-16ead9fd-1f3d-44dc-b7a7-e34b2607cab5'
act_path='0VJFMNV9K21X0NDVVON6P/'
act_region='eu-central-1'

act=$(cat << EOF
---
account:
  title: "$act_title"
  provider: 's3_wasabi'
  active: true
  settings:
    interval: '5000'
  services:
    - s3:
        access_key_id: "$act_key"
        secret_access_key: 'nBqczjAkbzcY7iE2twUGdgSzg7Z84KrVFXIgofJa'
        bucket: "$act_bucket"
        region: "$act_region"
        path: "$act_ssl"
        password: 'Y86B7D9BcjgwxzoJQnRSPDMvevZxSfTn794m'
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
    key_found=$(echo "$output" | grep ${act_key} | wc -l)
    [ $host_found -gt 0 ]
    bucket_found=$(echo "$output" | grep ${act_bucket} | wc -l)
    [ $bucket_found -gt 0 ]
    port_found=$(echo "$output" | grep ${act_region} | wc -l)
    [ $act_region -gt 0 ]
     port_found=$(echo "$output" | grep ${act_port} | wc -l)
    [ $act_region -gt 0 ]
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
