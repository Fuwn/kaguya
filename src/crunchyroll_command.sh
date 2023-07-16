if [ -n "${args[search]}" ]; then
	xdg-open https://www.crunchyroll.com/search?q="$(array_to_string "${args[search]}")"
else
	xdg-open https://www.crunchyroll.com/
fi
