#!/usr/bin/env bash
set -e

# Stelle sicher, dass wir im Verzeichnis des Skripts sind
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📦 Installing Tokyo Night KDE Rice Setup..."


# Packages to install
REQUIRED_PKGS=(
    kitty
    cmatrix
    neofetch
    wget#!
    unzip
    picom
    starship
)

echo "📦 Installing required packages..."
yay -S --noconfirm --needed "${REQUIRED_PKGS[@]}"

echo "📦 Installing required font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv


# Kitty conifg
echo "📁 Setting up Kitty config..."
mkdir -p ~/.config/kitty
mkdir -p ~/.config/kitty/themes
cp -r kitty/kitty.conf ~/.config/kitty/kitty.conf
cp -r kitty/themes/tokyonight.conf ~/.config/kitty/themes/tokyonight.conf

# Fonts
echo "🔤 Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
cp -r fonts/*.ttf ~/.local/share/fonts/
fc-cache -fv

# Plasma panel & color scheme
mkdir -p ~/.config
cp -r kde/plasma-org.kde.plasma.desktop-appletsrc ~/.config/
cp -r kde/kdeglobals ~/.config/

# GTK Themes
echo "🎨 Applying GTK settings..."
mkdir -p ~/.config/gtk-3.0
cp -r gtk/gtkrc-2.0 ~/.config/
cp -r gtk/settings.ini ~/.config/gtk-3.0/

# Color scheme file for KDE
mkdir -p ~/.local/share/color-schemes
cp -r kde/TokyoNight.colors ~/.local/share/color-schemes/

# Neofetch config
echo "📸 Setting up Neofetch..."
mkdir -p ~/.config/neofetch
cp -r neofetch/config.conf ~/.config/neofetch/config.conf

# Picom
cp -r picom/picom.conf ~/.config/picom.conf

# Starship
mkdir -p ~/.config/starship
cp starship/starship.toml ~/.config/starship/starship.toml

# Wallpaper installieren
echo "🖼 Installing wallpapers..."
mkdir -p ~/.local/share/backgrounds
cp wallpapers/vertical_wallpaper.jpg ~/.local/share/backgrounds/
cp wallpapers/horizontal_wallpaper.jpg ~/.local/share/backgrounds/



# Optional: Set as default terminal
if command -v xdg-settings &>/dev/null; then
  echo "💻 Setting Kitty as default terminal..."
  xdg-settings set default-terminal kitty || true
fi

echo "✅ Installation complete! ✨"
echo "🔁 Please restart Plasam or logout"
echo "💡 Start kitty and neofetch to test the setup"
