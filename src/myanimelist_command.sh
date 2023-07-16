if [ -n "${args[profile]}" ]; then
	xdg-open https://myanimelist.net/profile/"${args[profile]}"
else
	xdg-open https://myanimelist.net
fi
