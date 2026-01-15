#!/bin/bash

sudo pacman -Syu

sudo pacman -S --needed git base-devel

if [ ! -d "$HOME/.yay" ]; then
    git clone https://aur.archlinux.org/yay.git "$HOME/.yay"
    cd "$HOME/.yay" || exit
    makepkg -si
    cd - || exit
else
    echo "Yay is already installed."
fi