# Default to anime, permit manga
if [[ "${args[--manga]}" = 1 ]]; then
	FORMAT="manga"
	TYPE="manga"
	FILTER="format"
elif [[ "${args[--novel]}" = 1 ]]; then
	FORMAT="novel"
	TYPE="manga"
	FILTER="format"
elif [[ "${args['--any-manga']}" = 1 ]]; then
	FORMAT="manga"
	TYPE="manga"
	FILTER="type"
else
	FORMAT="tv"
	TYPE="anime"
	FILTER="format"
fi

TITLE=$(array_to_string "${args[title]}")

# Obtain media IDs from AniList
ID=$(curl 'https://graphql.anilist.co/' \
	--silent \
	--request POST \
	--header 'Content-Type: application/json' \
	--header 'Accept: application/json' \
	--data "{ \"query\": \"{ Media(search: \\\"${TITLE}\\\", \
    ${FILTER}: $(echo "${FORMAT}" | tr '[:lower:]' '[:upper:]' || true)) { id idMal } }\" }")

# Open the anime or manga in AniList by default, permit MyAnimeList
if [[ "${args[--mal]}" = 1 ]]; then
	if [[ "${args[--social]}" = 1 ]]; then
		FULL_URL=$(curl --silent \
			"https://api.jikan.moe/v4/anime/$(echo "${ID}" |
				jq '.data.Media.idMal')/full" || true)

		xdg-open "$(echo "${FULL_URL}" | jq -r '.data.url' || true)/forum"
	else
		xdg-open https://myanimelist.net/"${TYPE}"/"$(echo "${ID}" | jq '.data.Media.idMal' || true)"
	fi
else
	if [[ "${args[--social]}" = 1 ]]; then
		xdg-open https://anilist.co/"${TYPE}"/"$(echo "${ID}" | jq '.data.Media.id' || true)"/social
	else
		xdg-open https://anilist.co/"${TYPE}"/"$(echo "${ID}" | jq '.data.Media.id' || true)"
	fi
fi
