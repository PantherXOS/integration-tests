
@test "test event pub/sub" {
  run python3 event-helper.py
  if [ "$status" -ne 0 ]; then
    echo "$output" >&3;
  fi
  [ $status -eq 0 ]
  [ $(echo "$output" | grep 'subscriber connected' | wc -l) -eq 1 ]
  [ $(echo "$output" | grep 'publisher connected' | wc -l) -eq 1 ]
  [ $(echo "$output" | grep 'topic = "account"' | wc -l) -eq 2 ]
  [ $(echo "$output" | grep 'source = "test app",' | wc -l) -eq 2 ]
  [ $(echo "$output" | grep 'everything done' | wc -l) -eq 1 ]
}
