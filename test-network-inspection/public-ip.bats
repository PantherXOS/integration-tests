
pantherx_ip_service="https://my-ip.pantherx.org/ip"

@test "Public IP Check" {
	# Checks if the public IP mathces the primary path IP
	run px-network-inspection -o ./output.json
	[ "$status" -eq 0 ]
	run curl "$pantherx_ip_service"
	curlout="${lines[3]}"
	run jq .primary[0].ip4 output.json
	temp="${output%\"}"
	temp="${temp#\"}"
	[ "$curlout" == "$temp" ]
}
