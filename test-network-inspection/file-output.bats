
output_file="./output.json"

@test "Check Output File" {
	# The px-network-inspection creats output JSON file
	run px-network-inspection -o "$output_file"

	[ -f "$output_file" ]
	[ "$status" -eq 0 ]
}
