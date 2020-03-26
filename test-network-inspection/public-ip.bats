
pantherx_ip_service="https://my-ip.pantherx.org/ip"

@test "Public IP Check" {
	# Checks if the public IP mathces the primary path IP
	run curl "$pantherx_ip_service"
	#echo "${lines[3]}" >&3
	[ "$status" -eq 0 ]
	[ "${lines[3]}" = "5.113.238.145" ]
}
