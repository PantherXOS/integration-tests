
cleanup_account() {
  if [ -e "$HOME/.userdata/accounts/$1" ]; then
    run rm "$HOME/.userdata/accounts/$1"
    [ "$status" -eq 0 ]
  fi
}