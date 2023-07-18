if [[ -n "${args[--dub]}" ]]; then
	ani-cli --dub "$(array_to_string "${args[search]}" || true)"
else
	ani-cli "$(array_to_string "${args[search]}" || true)"
fi
