
@test "OpenVPN Check" {
	# Checks if the VPN information is correct
	skip	
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
		run jq .primary[2].profile ./output.json
		prf="${output%\"}"
		prf="${prf#\"}"
		prf_res=`ps -aef | grep -v "grep" | grep openvpn | grep ${prf}`
	fi
}
