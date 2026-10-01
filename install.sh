#!/bin/bash
# Installs yt2mp3 as a recognized command, and installs all missing
# dependencies automatically.
set -u

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_SRC="$REPO_DIR/bin/yt2mp3.sh"
COMMAND_NAME="yt2mp3"

PKG_MANAGER=""
if command -v apt-get >/dev/null 2>&1; then
    PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="zypper"
fi

install_packages() {
    case "$PKG_MANAGER" in
        apt)
            sudo apt-get update -qq
            sudo apt-get install -y "$@"
            ;;
        dnf)
            sudo dnf install -y "$@"
            ;;
        pacman)
            sudo pacman -Sy --needed --noconfirm "$@"
            ;;
        zypper)
            sudo zypper install -y "$@"
            ;;
        *)
            return 1
            ;;
    esac
}

install_chrome() {
    if command -v google-chrome >/dev/null 2>&1 || command -v google-chrome-stable >/dev/null 2>&1; then
        return 0
    fi

    case "$PKG_MANAGER" in
        apt)
            TMP_DEB="$(mktemp --suffix=.deb)"
            curl -fsSL -o "$TMP_DEB" https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
                && sudo apt-get install -y "$TMP_DEB"
            rm -f "$TMP_DEB"
            ;;
        dnf)
            sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
            ;;
        pacman)
            # Google Chrome is AUR-only on Arch; chromium is the officially
            # supported fallback (yt-dlp also accepts --cookies-from-browser chromium).
            sudo pacman -Sy --needed --noconfirm chromium
            ;;
        zypper)
            sudo zypper install -y chromium
            ;;
        *)
            return 1
            ;;
    esac
}

echo "Installing yt2mp3 command..."
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
echo "Checking dependencies..."

if command -v yt-dlp >/dev/null 2>&1; then
    echo "  [OK] yt-dlp"
else
    echo "  [INSTALLING] yt-dlp"
    install_packages yt-dlp || echo "  [FAILED] could not install yt-dlp automatically, install it manually: https://github.com/yt-dlp/yt-dlp#installation"
fi

if command -v ffmpeg >/dev/null 2>&1; then
    echo "  [OK] ffmpeg"
else
    echo "  [INSTALLING] ffmpeg"
    install_packages ffmpeg || echo "  [FAILED] could not install ffmpeg automatically, install it manually with your package manager"
fi

if [ -x "$HOME/.deno/bin/deno" ] || command -v deno >/dev/null 2>&1; then
    echo "  [OK] deno"
else
    echo "  [INSTALLING] deno"
    curl -fsSL https://deno.land/install.sh | sh -s -- >/dev/null 2>&1 \
        && echo "  [OK] deno" \
        || echo "  [FAILED] could not install deno automatically, see https://deno.land/#installation"
fi

if command -v google-chrome >/dev/null 2>&1 || command -v google-chrome-stable >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1; then
    echo "  [OK] chrome/chromium"
else
    echo "  [INSTALLING] google-chrome (or chromium fallback)"
    install_chrome \
        && echo "  [OK] chrome/chromium" \
        || echo "  [FAILED] could not install a Chromium-based browser automatically, install Google Chrome or Chromium manually"
fi

echo
echo "Usage: $COMMAND_NAME \"URL\" [--playlist]"
