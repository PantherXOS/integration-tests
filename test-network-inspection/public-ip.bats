
pantherx_ip_service="https://my-ip.pantherx.org/ip""

@test "Public IP Check" {
	curl "$pantherx_ip_service"
	echo "$output"
	[ "$status" eq 0 ]
}
