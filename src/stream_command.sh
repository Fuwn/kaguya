if [[ -n "${args['--download']}" ]]; then
	START=$(date +%s)

	yt-dlp --format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best' --cookies-from-browser "${args[--browser]}" --all-subs --embed-subs "${args[uri]}"

	printf "\ntook %s seconds\n" $(($(date +%s || true) - START))

	return
fi

mpv --ytdl-raw-options-append=format='bestvideo[ext=mp4]+bestaudio[ext=m4a]/best' --ytdl-raw-options-append=cookies-from-browser="${args[--browser]}" "${args[uri]}"
