if [[ -n "${args[search]}" ]]; then
	xdg-open https://www.hidive.com/search?q="$(array_to_string "${args[search]}" || true)"
else
	xdg-open https://www.hidive.com/
fi
