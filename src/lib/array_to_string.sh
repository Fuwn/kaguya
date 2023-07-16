array_to_string() {
	array="${1}"

	echo "${array[*]// / }" | tr -d '"'
}
