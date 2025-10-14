#!/bin/bash

# Dotfiles setup script
# This script creates symbolic links from the dotfiles directory to the home directory

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up dotfiles from: $DOTFILES_DIR"
echo ""

# Tmux configuration
echo "Linking tmux configuration..."
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
echo "  ✓ ~/.tmux.conf -> $DOTFILES_DIR/tmux/tmux.conf"

# Vim configuration
echo "Linking vim configuration..."
ln -sf "$DOTFILES_DIR/vim/vimrc.local" "$HOME/.vimrc.local"
echo "  ✓ ~/.vimrc.local -> $DOTFILES_DIR/vim/vimrc.local"

ln -sf "$DOTFILES_DIR/vim/vimrc.bundles.local" "$HOME/.vimrc.bundles.local"
echo "  ✓ ~/.vimrc.bundles.local -> $DOTFILES_DIR/vim/vimrc.bundles.local"

# Hyprland configuration
echo "Linking hyprland configuration..."
mkdir -p "$HOME/.config/hypr"
ln -sf "$DOTFILES_DIR/hyprland/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
echo "  ✓ ~/.config/hypr/hyprland.conf -> $DOTFILES_DIR/hyprland/hyprland.conf"

# Hyprpaper configuration
echo "Linking hyprpaper configuration..."
ln -sf "$DOTFILES_DIR/hyprland/hyprpaper.conf" "$HOME/.config/hypr/hyprpaper.conf"
echo "  ✓ ~/.config/hypr/hyprpaper.conf -> $DOTFILES_DIR/hyprland/hyprpaper.conf"

# Hyprpaper configuration
echo "Linking hyprlock configuration..."
ln -sf "$DOTFILES_DIR/hyprland/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
echo "  ✓ ~/.config/hypr/hyprlock.conf -> $DOTFILES_DIR/hyprland/hyprlock.conf"

# Waybar configuration
echo "Linking waybar configuration..."
mkdir -p "$HOME/.config/waybar"
for file in "$DOTFILES_DIR/hyprland/waybar"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        ln -sf "$file" "$HOME/.config/waybar/$filename"
        echo "  ✓ ~/.config/waybar/$filename -> $file"
    fi
done

echo ""
echo "Dotfiles setup complete!"
