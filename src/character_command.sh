NAME=$(array_to_string "${args[name]}")

# Obtain media IDs from AniList
ID=$(curl 'https://graphql.anilist.co/' \
	--silent \
	--request POST \
	--header 'Content-Type: application/json' \
	--header 'Accept: application/json' \
	--data "{ \"query\": \"{ Character(search: \\\"${NAME}\\\") \
    { id } }\" }")

xdg-open https://anilist.co/character/"$(echo "${ID}" |
	jq '.data.Character.id' || true)"
