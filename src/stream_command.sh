user_agent="${args['--user-agent']}"

if [[ -n "${args['--download']}" ]]; then
	START=$(date +%s)

	download_command=(
		yt-dlp
		--format 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best'
		--cookies-from-browser "${args[--browser]}"
		--all-subs
		--embed-subs
	)

	if [ -n "${user_agent}" ]; then
		download_command+=(--user-agent "${user_agent}")
	fi

	download_command+=("${args[uri]}")

	"${download_command[@]}"

	printf "\ntook %s seconds\n" $(($(date +%s || true) - START))

	return
fi

stream_command=(
	mpv
	--ytdl-raw-options-append=format='bestvideo[ext=mp4]+bestaudio[ext=m4a]/best'
	--ytdl-raw-options-append=cookies-from-browser="${args[--browser]}"
	--af="scaletempo=stride=28:overlap=.9:search=25"
)

if [ -n "${user_agent}" ]; then
	stream_command+=(--ytdl-raw-options-append=user-agent="${user_agent}")
fi

stream_command+=("${args[uri]}")

"${stream_command[@]}"
