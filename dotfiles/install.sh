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
mkdir -p "$SCRIPT_DIR/fonts"
cd "$SCRIPT_DIR/fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip -o "$SCRIPT_DIR/fonts/JetBrainsMono.zip" -d "$SCRIPT_DIR/fonts"
fc-cache -fv


# Kitty conifg
echo "📁 Setting up Kitty config..."
if [ -f ~/.config/kitty ]; then
  echo "⚠️  Achtung: ~/.config/kitty ist eine Datei, aber es sollte ein Verzeichnis sein. Lösche es..."
  rm ~/.config/kitty
fi
mkdir -p ~/.config/kitty
mkdir -p ~/.config/kitty/themes
cp "$SCRIPT_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf
cp "$SCRIPT_DIR/kitty/themes/tokyonight.conf" ~/.config/kitty/themes/tokyonight.conf

# Fonts
echo "🔤 Kopiere Fonts..."
mkdir -p ~/.local/share/fonts

shopt -s nullglob
for font in "$SCRIPT_DIR/fonts/"*.ttf; do
  echo "→ $font"
  cp "$font" ~/.local/share/fonts/
done
fc-cache -fv

# Plasma panel & color scheme
mkdir -p ~/.config
cp "$SCRIPT_DIR/kde/plasma-org.kde.plasma.desktop-appletsrc" ~/.config/
cp "$SCRIPT_DIR/kde/kdeglobals" ~/.config/

# GTK Themes
echo "🎨 Applying GTK settings..."
mkdir -p ~/.config/gtk-3.0
cp "$SCRIPT_DIR/gtk/gtkrc-2.0" ~/.config/
cp "$SCRIPT_DIR/gtk/settings.ini" ~/.config/gtk-3.0/

# Color scheme file for KDE
mkdir -p ~/.local/share/color-schemes
cp "$SCRIPT_DIR/kde/TokyoNight.colors" ~/.local/share/color-schemes/

# Neofetch config
echo "📸 Setting up Neofetch..."
mkdir -p ~/.config/neofetch
cp "$SCRIPT_DIR/neofetch/config.conf" ~/.config/neofetch/config.conf

# Picom
cp "$SCRIPT_DIR/picom/picom.conf" ~/.config/picom.conf

# Starship
mkdir -p ~/.config/starship
cp "$SCRIPT_DIR/starship/starship.toml" ~/.config/starship/starship.toml

# Wallpaper installieren
echo "🖼 Installing wallpapers..."
mkdir -p ~/.local/share/backgrounds
if [ -f "$SCRIPT_DIR/wallpapers/vertical_wallpaper.jpg" ]; then
  cp "$SCRIPT_DIR/wallpapers/vertical_wallpaper.jpg" ~/Pictures/
else
  echo "⚠️  vertical_wallpaper.jpg wurde nicht gefunden – überspringe..."
fi



# Optional: Set as default terminal
if command -v xdg-settings &>/dev/null; then
  echo "💻 Setting Kitty as default terminal..."
  xdg-settings set default-terminal kitty || true
fi

echo "✅ Installation complete! ✨"
echo "🔁 Please restart Plasam or logout"
echo "💡 Start kitty and neofetch to test the setup"
