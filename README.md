# yt2mp3

Petit script en ligne de commande pour télécharger une vidéo YouTube (ou une playlist entière) et la convertir directement en MP3, avec une barre de progression pour les playlists.

## Prérequis

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) — moteur de téléchargement
- `ffmpeg` — conversion audio
- [`deno`](https://deno.land/#installation) — requis par `yt-dlp` pour certains contournements anti-bot de YouTube
- Google Chrome installé (le script lit les cookies de Chrome via `--cookies-from-browser chrome` pour accéder aux vidéos nécessitant une connexion)

## Installation

```bash
git clone git@github.com:Twistmac/yt2mp3.git
cd yt2mp3
./install.sh
```

`install.sh` :
- rend `bin/yt2mp3.sh` exécutable et l'installe sous le nom `yt2mp3`, dans `/usr/local/bin` (si accessible via `sudo`) ou sinon dans `~/.local/bin` (ajouté automatiquement au `PATH` si besoin) ;
- vérifie la présence de `yt-dlp`, `ffmpeg` et `deno`, et affiche les commandes d'installation correspondantes (apt/dnf/pacman) si l'une d'elles manque.

## Utilisation

```bash
yt2mp3 "URL"                # télécharge une seule vidéo
yt2mp3 "URL" --playlist     # télécharge toute la playlist, avec barre de progression
```

Les fichiers MP3 sont enregistrés dans le dossier courant, c'est-à-dire celui depuis lequel la commande est lancée.

## Qualité et format

Le script télécharge le meilleur flux audio disponible et le convertit en MP3 à la meilleure qualité (`--audio-quality 0`), sans conserver la miniature, la description ni les métadonnées JSON de la vidéo.

## Dépannage

- **`yt2mp3: command not found`** : ouvre un nouveau terminal (ou exécute `source ~/.bashrc` / `source ~/.zshrc`) après l'installation, le temps que le `PATH` soit rechargé.
- **Erreur liée aux cookies / connexion** : assure-toi que Chrome est installé et que tu es connecté à ton compte Google dedans si la vidéo le nécessite.
- **Erreur liée à `deno`** : vérifie que `deno` est bien installé dans `~/.deno/bin/deno` ou accessible dans le `PATH`.
