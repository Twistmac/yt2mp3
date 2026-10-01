# yt2mp3

Télécharge une vidéo YouTube (ou une playlist) et la convertit en MP3.

## Installation

Dépendances requises : [`yt-dlp`](https://github.com/yt-dlp/yt-dlp), `ffmpeg`, [`deno`](https://deno.land/#installation).

```bash
git clone git@github.com:Twistmac/yt2mp3.git
cd yt2mp3
./install.sh
```

Le script installe la commande `yt2mp3` dans `/usr/local/bin` (si accessible avec `sudo`), sinon dans `~/.local/bin` (ajouté automatiquement au `PATH`).

## Utilisation

```bash
yt2mp3 "URL"                # une seule vidéo
yt2mp3 "URL" --playlist     # toute la playlist
```

Les fichiers MP3 sont enregistrés dans le dossier courant (celui depuis lequel la commande est lancée).
