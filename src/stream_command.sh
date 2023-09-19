user_agent="Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20100101 Firefox/10.0"

if [[ -n "${args['--download']}" ]]; then
	START=$(date +%s)

	yt-dlp \
		--all-subs \
		--cookies-from-browser firefox \
		--embed-subs \
		--external-downloader=aria2c \
		--external-downloader-args \
		'--min-split-size=1M --max-connection-per-server=16 --max-concurrent-downloads=16 --split=16' \
		-f 'best[height=1080]' \
		--remux mkv \
		--merge mkv \
		--verbose \
		--user-agent "${user_agent}" \
		"${args[uri]}"

	printf "\ntook %s seconds\n" $(($(date +%s || true) - START))

	return
fi

# mpv "$(yt-dlp \
# 	--cookies-from-browser firefox \
# 	--extractor-args crunchyrollbeta:hardsub=en-US \
# 	-f 'best[height=1080]' \
# 	-g \
# 	--verbose \
# 	"${1}")"

subtitles_command=(
	'yt-dlp'
	'--cookies-from-browser' 'firefox'
	'--no-download'
	'-o' '/tmp/skyla_subtitles'
	'--sub-lang' 'en-US'
	'--write-subs'
	'--user-agent' "${user_agent}"
	"${args[uri]}"
)

if [ -n "${args['--username']}" ]; then
	subtitles_command+=(-u "${args['--username']}")
	subtitles_command+=(-p "${args['--password']}")
fi

"${subtitles_command[@]}"

if [[ -n "${args['--fix']}" ]]; then
	sed -i 's/{an\d*}//g' /tmp/skyla_subtitles.*.ass
fi

media_command=(
	'yt-dlp'
	'--cookies-from-browser' 'firefox'
	'-f' 'best[height=1080]'
	'-g'
	'--user-agent' "${user_agent}"
	"${args[uri]}"
)

if [ -n "${args['--username']}" ]; then
	media_command+=(-u "${args['--username']}")
	media_command+=(-p "${args['--password']}")
fi

mplayer \
	-sub /tmp/skyla_subtitles.*.ass \
	"$("${media_command[@]}")"

rm /tmp/skyla_subtitles.*.ass
