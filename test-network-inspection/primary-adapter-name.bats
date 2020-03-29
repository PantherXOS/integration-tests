
@test "Primary Adapter Name" {
	# Checks if the primary physical adaptr name is correct
	run px-network-inspection -o ./output.json
	[ "$status" -eq 0 ]
	run jq .primary[1].ip4 output.json
	ip4="${output%\"}"
	ip4="${ip4#\"}"
	run jq .primary[1].adapter output.json
	adapter="${output%\"}"
	adapter="${adapter#\"}"
	tempip4=`ip -4 addr show dev ${adapter} | grep inet | tr -s " " | cut -d" " -f3 | head -n 1`
	tempip4=${tempip4%/*}
	[ "$ip4" == "$tempip4" ]
}
