user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20100101 Firefox/10.0"

if [[ -n "${args['--download']}" ]]; then
	START=$(date +%s)

	yt_dlp_command=(
		"yt-dlp"
		"--all-subs"
		"--cookies-from-browser" "firefox"
		"--embed-subs"
		'-f' 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best'
		"--verbose"
		"--user-agent" "${user_agent}"
		"${args[uri]}"
	)

	if [ -n "${args['--username']}" ] || [ -n "${args['--password']}" ]; then
		yt_dlp_command+=(-u "${args['--username']}")
		yt_dlp_command+=(-p "${args['--password']}")
	fi

	if [ -n "${args['--cookies']}" ]; then
		yt_dlp_command+=(--cookies "${args['--cookies']}")
	fi

	if [ -n "${args['--aria2c']}" ]; then
		yt_dlp_command+=('--external-downloader=aria2c')
		yt_dlp_command+=('--external-downloader-args')
		yt_dlp_command+=('--min-split-size=1M --max-connection-per-server=16 --max-concurrent-downloads=16 --split=16')
	fi

	"${yt_dlp_command[@]}"

	printf "\ntook %s seconds\n" $(($(date +%s || true) - START))

	return
fi

subtitles_command=(
	'yt-dlp'
	'--cookies-from-browser' 'firefox'
	'--no-download'
	'-o' '/tmp/skyla_subtitles'
	'--sub-lang' "${args['--language']}"
	'--write-subs'
	'--user-agent' "${user_agent}"
	"${args[uri]}"
)

if [ -n "${args['--username']}" ] || [ -n "${args['--password']}" ]; then
	subtitles_command+=(-u "${args['--username']}")
	subtitles_command+=(-p "${args['--password']}")
fi

if [ -n "${args['--cookies']}" ]; then
	subtitles_command+=(--cookies "${args['--cookies']}")
fi

"${subtitles_command[@]}"

if [[ -n "${args['--fix']}" ]]; then
	sed -i 's/{an\d*}//g' /tmp/skyla_subtitles.*.ass
fi

media_command=(
	'yt-dlp'
	'--cookies-from-browser' 'firefox'
	'-f' 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio/best'
	'-g'
	'--user-agent' "${user_agent}"
	"${args[uri]}"
)

if [ -n "${args['--username']}" ]; then
	media_command+=(-u "${args['--username']}")
	media_command+=(-p "${args['--password']}")
fi

memento \
	--sub-file="/tmp/skyla_subtitles.${args['--language']}.ass" \
	"$("${media_command[@]}")"

rm /tmp/skyla_subtitles.*.ass
