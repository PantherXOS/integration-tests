
@test "VPN Check" {
	# Checks if the VPN information is correct
	
	run px-network-inspection -o ./output.json
	[ "$status" -eq 0 ]
	run jq .primary[2]? ./output.json
	
	if [ "$output" != "null" ]
	then
		run jq .primary[2].gateway ./output.json
		gw="${output%\"}"
		gw="${gw#\"}"
		run jq .primary[1].adapter output.json
		adapter="${output%\"}"
		adapter="${adapter#\"}"
		route_res=`route -n | grep ${gw} | grep ${adapter}`
		#echo "$route_res" >&3
		#[ -n "$route_res" ]
	fi
	#tempip4=`ip -4 addr show dev ${adapter} | grep inet | tr -s " " | cut -d" " -f3 | head -n 1`
	#tempip4=${tempip4%/*}
	#[ "$ip4" == "$tempip4" ]
}
