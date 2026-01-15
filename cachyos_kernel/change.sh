#!/bin/bash
set -e

REPO_URL="https://mirror.cachyos.org/cachyos-repo.tar.xz"
ARCHIVE="cachyos-repo.tar.xz"
DIR="cachyos-repo"

download_and_extract() {
    echo "Downloading CachyOS repo..."
    curl -fsSL "$REPO_URL" -o "$ARCHIVE"

    echo "Extracting archive..."
    tar -xf "$ARCHIVE"
}

cleanup() {
    rm -rf "$ARCHIVE" "$DIR"
}

echo "=============================="
echo "Choose the option:"
echo "1. Install CachyOS Kernel"
echo "2. Uninstall CachyOS Kernel"
echo "3. Exit"
echo "=============================="

read -rp "Input your option (1/2/3): " OPTION

# Validasi input numerik
if ! [[ "$OPTION" =~ ^[1-3]$ ]]; then
    echo "❌ Invalid option"
    exit 1
fi

case "$OPTION" in
    1)
        download_and_extract
        cd "$DIR"
        sudo ./cachyos-repo.sh
        ;;
    2)
        download_and_extract
        cd "$DIR"
        sudo ./cachyos-repo.sh --remove
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
esac

cleanup
echo "✅ Done."