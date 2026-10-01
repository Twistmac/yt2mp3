#!/bin/bash
# Installs yt2mp3 as a recognized command on the system.
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_SRC="$REPO_DIR/bin/yt2mp3.sh"
COMMAND_NAME="yt2mp3"

chmod +x "$SCRIPT_SRC"

if [ -w /usr/local/bin ] || sudo -n true 2>/dev/null; then
    DEST="/usr/local/bin/$COMMAND_NAME"
    sudo install -m 755 "$SCRIPT_SRC" "$DEST"
else
    mkdir -p "$HOME/.local/bin"
    DEST="$HOME/.local/bin/$COMMAND_NAME"
    install -m 755 "$SCRIPT_SRC" "$DEST"

    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *)
            SHELL_RC="$HOME/.bashrc"
            case "$SHELL" in
                */zsh) SHELL_RC="$HOME/.zshrc" ;;
            esac
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
            echo "Added \$HOME/.local/bin to PATH in $SHELL_RC (restart your terminal)."
            ;;
    esac
fi

echo "yt2mp3 installed: $DEST"

echo
echo "Checking dependencies:"
for cmd in yt-dlp ffmpeg; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "  [OK] $cmd"
    else
        echo "  [MISSING] $cmd"
    fi
done

if [ -x "$HOME/.deno/bin/deno" ] || command -v deno >/dev/null 2>&1; then
    echo "  [OK] deno"
else
    echo "  [MISSING] deno (see https://deno.land/#installation)"
fi

echo
echo "Install the missing dependencies with your distribution's package manager, for example:"
echo "  Debian/Ubuntu : sudo apt install yt-dlp ffmpeg"
echo "  Fedora        : sudo dnf install yt-dlp ffmpeg"
echo "  Arch          : sudo pacman -S yt-dlp ffmpeg"
echo
echo "Usage: $COMMAND_NAME \"URL\" [--playlist]"
