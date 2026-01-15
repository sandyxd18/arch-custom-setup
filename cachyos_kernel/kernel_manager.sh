#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/cachyos/kernel-manager.git"
REPO_DIR="kernel-manager"
PREFIX="/usr/local"

echo "==> Installing dependencies..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    cmake \
    pkg-config \
    make \
    qt6-base \
    qt6-tools \
    polkit-qt6 \
    python

echo "==> Cloning repository..."
if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists, skipping clone."
else
    git clone "$REPO_URL"
fi

cd "$REPO_DIR"

echo "==> Configuring build (prefix=$PREFIX)..."
chmod +x configure.sh build.sh
./configure.sh --prefix="$PREFIX"

echo "==> Building..."
./build.sh

echo "==> Build finished successfully."