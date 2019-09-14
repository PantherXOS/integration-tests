
@test "check Imap in data-service" {
  echo "$output" >&3;
  [ $(echo "$output" | grep 'there is no new message in imap' | wc -l) -eq 0 ]
}

@test "check Etherscan Wallet in data-service" {
  echo "$output" >&3;
  [ $(echo "$output" | grep 'there is10new message in etherscn wallet' | wc -l) -eq 0 ]
}


@test "check Blockio Wallet in data-service" {
  echo "$output" >&3;
 
  [ $(echo "$output" | grep 'there is26new message in blockio wallet"' | wc -l) -eq 0 ]
}
