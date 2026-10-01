#!/bin/bash
# usage : yt2mp3.sh "URL" [--playlist]
DOSSIER="$(pwd)"

OPTS="-f bestaudio/best -x --audio-format mp3 --audio-quality 0 --no-write-thumbnail --no-write-description --no-write-info-json --js-runtimes deno:$HOME/.deno/bin/deno --remote-components ejs:github --cookies-from-browser chrome"

show_progress() {
    local cur total percent filled empty bar spaces
    while IFS= read -r line; do
        if [[ "$line" =~ Downloading\ item\ ([0-9]+)\ of\ ([0-9]+) ]]; then
            cur="${BASH_REMATCH[1]}"
            total="${BASH_REMATCH[2]}"
            percent=$((cur * 100 / total))
            filled=$((percent / 2))
            empty=$((50 - filled))
            bar=$(printf "%${filled}s" | tr ' ' '#')
            spaces=$(printf "%${empty}s")
            printf "\r[%s%s] %d%% (%d/%d)" "$bar" "$spaces" "$percent" "$cur" "$total"
        fi
    done
    echo
}

if [ "$2" == "--playlist" ]; then
    yt-dlp $OPTS -o "$DOSSIER/%(title)s.%(ext)s" "$1" | show_progress
else
    yt-dlp $OPTS --no-playlist -o "$DOSSIER/%(title)s.%(ext)s" "$1"
fi
