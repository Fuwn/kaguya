if [ -n "${args[profile]}" ]; then
	xdg-open https://anilist.co/user/"${args[profile]}"
else
	xdg-open https://anilist.co/home
fi
