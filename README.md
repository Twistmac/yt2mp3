# yt2mp3

A small command-line script to download a YouTube video (or an entire playlist) and convert it directly to MP3, with a progress bar for playlists.

## Requirements

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) — download engine
- `ffmpeg` — audio conversion
- [`deno`](https://deno.land/#installation) — required by `yt-dlp` for some of YouTube's anti-bot workarounds
- Google Chrome installed (the script reads Chrome's cookies via `--cookies-from-browser chrome` to access videos that require being signed in)

## Installation

```bash
git clone git@github.com:Twistmac/yt2mp3.git
cd yt2mp3
./install.sh
```

`install.sh`:
- makes `bin/yt2mp3.sh` executable and installs it as `yt2mp3`, in `/usr/local/bin` (if accessible via `sudo`) or otherwise in `~/.local/bin` (automatically added to `PATH` if needed);
- automatically installs any missing dependency (`yt-dlp`, `ffmpeg`, `deno`, Google Chrome/Chromium) using your distribution's package manager (apt, dnf, pacman, zypper) — no manual step required.

## Usage

```bash
yt2mp3 "URL"                # download a single video
yt2mp3 "URL" --playlist     # download the whole playlist, with a progress bar
```

MP3 files are saved in the current directory, i.e. the one the command is run from.

## Quality and format

The script downloads the best available audio stream and converts it to MP3 at the highest quality (`--audio-quality 0`), without keeping the video thumbnail, description, or JSON metadata.

## Troubleshooting

- **`yt2mp3: command not found`**: open a new terminal (or run `source ~/.bashrc` / `source ~/.zshrc`) after installing, to let the updated `PATH` take effect.
- **Cookie/sign-in related error**: make sure Chrome is installed and that you're signed in to your Google account there if the video requires it.
- **`deno`-related error**: check that `deno` is installed at `~/.deno/bin/deno` or available in your `PATH`.
