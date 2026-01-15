#!/bin/bash

set -e

echo "==> Install base packages..."
sudo pacman -S --needed \
    swww \
    hyprpaper \
    zsh \
    rofi \
    waybar \
    swaync \
    grim \
    xdg-user-dirs \
    exa

echo "==> Copy Hyprland configuration..."
cp -r hyprland_config/hyprland.conf "$HOME/.config/hyprland"

echo "==> Start background services..."
pgrep swww-daemon || (swww-daemon & disown)
pgrep waybar || (waybar & disown)

echo "==> Restart swaync..."
killall -9 swaync 2>/dev/null || true
swaync & disown

echo "==> Change default shell to zsh..."
if [[ "$SHELL" != "/bin/zsh" ]]; then
    chsh -s /bin/zsh
    echo "⚠️ Logout required to apply shell change"
fi