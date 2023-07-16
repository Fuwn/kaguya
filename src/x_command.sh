# Default to anime, permit manga
if [ "${args[--manga]}" = 1 ]; then
	TYPE="manga"
else
	TYPE="anime"
fi

TITLE=$(array_to_string "${args[title]}")

# Obtain media IDs from AniList
ID=$(curl 'https://graphql.anilist.co/' \
	--silent \
	--request POST \
	--header 'Content-Type: application/json' \
	--header 'Accept: application/json' \
	--data "{ \"query\": \"{ Media(search: \\\"${TITLE}\\\", \
    type: $(echo ${TYPE} | tr '[:lower:]' '[:upper:]')) { id idMal } }\" }")

# Open the anime or manga in AniList by default, permit MyAnimeList
if [ "${args[--mal]}" = 1 ]; then
	xdg-open https://myanimelist.net/${TYPE}/"$(echo "${ID}" | jq '.data.Media.idMal')"
else
	if [ "${args[--social]}" = 1 ]; then
		xdg-open https://anilist.co/${TYPE}/"$(echo "${ID}" | jq '.data.Media.id')"/social
	else
		xdg-open https://anilist.co/${TYPE}/"$(echo "${ID}" | jq '.data.Media.id')"
	fi
fi
