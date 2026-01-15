#!/usr/bin/env bash

set -e

echo "==> Search Nerd Fonts (Caskaydia)..."
yay -Ss caskaydiacove || true
yay -Ss caskaydia || true

echo "==> Configure Kitty terminal..."
KITTY_CONFIG_DIR="$HOME/.config/kitty"

mkdir -p "$KITTY_CONFIG_DIR"
cp kitty_config/kitty.conf "$KITTY_CONFIG_DIR/kitty.conf"

echo "==> Install Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

echo "==> Install Powerlevel10k theme..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

echo "==> Configure .zshrc..."
ZSHRC="$HOME/.zshrc"

if ! grep -q "powerlevel10k/powerlevel10k" "$ZSHRC"; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
fi

if ! grep -q "alias ls=" "$ZSHRC"; then
    echo 'alias ls="exa -l"' >> "$ZSHRC"
fi

echo "==> Update XDG user dirs..."
xdg-user-dirs-update

echo "==> Reload zsh config..."
source "$ZSHRC" || true

echo "==> Setup Rofi configuration..."
ROFI_DIR="$HOME/.config/rofi"

mkdir -p "$ROFI_DIR"

if [[ ! -d "$ROFI_DIR/.git" ]]; then
    git clone --depth=1 https://github.com/adi1090x/rofi.git /tmp/rofi-tmp
    cp -r /tmp/rofi-tmp/files/{colors,config.rasi,launchers} "$ROFI_DIR"
    rm -rf /tmp/rofi-tmp
fi

echo "==> Configure Rofi launcher theme..."
LAUNCHER_DIR="$ROFI_DIR/launchers/type-2"

sed -i 's/theme=.*/theme="style-2"/' "$LAUNCHER_DIR/launcher.sh"

echo "==> Configure Rofi colors..."
cat > "$LAUNCHER_DIR/shared/colors.rasi" <<EOF
@import "~/.config/rofi/colors/onedark.rasi"
EOF

echo "==> Configure Rofi fonts..."
cat > "$LAUNCHER_DIR/shared/fonts.rasi" <<EOF
* {
    font: "GeistMono Nerd Font 10";
}
EOF

echo "==> Setup Waybar configuration..."
WAYBAR_DIR="$HOME/.config/waybar"

mkdir -p "$WAYBAR_DIR"

echo "==> Copy Waybar config files..."
cd waybar_config
cp config.jsonc style.css one-dark.css launch.sh "$WAYBAR_DIR"

# echo "✅ Setup selesai!"
# echo "➡️ Silakan logout / reboot agar semua perubahan aktif."