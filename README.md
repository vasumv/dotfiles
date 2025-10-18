# Dotfiles

Personal configuration files for Linux development environment with Hyprland.

## Overview

This repository contains configuration files for:
- **Hyprland**: Wayland compositor
- **Waybar**: Status bar for Hyprland
- **Hyprpaper**: Wallpaper utility
- **Hyprlock**: Screen locker
- **Fuzzel**: Application launcher
- **Tmux**: Terminal multiplexer
- **Vim**: Text editor

## Prerequisites

### Required Packages

Install the following packages on Arch Linux:

```bash
# Core Hyprland environment
sudo pacman -S hyprland hyprpaper hyprlock waybar fuzzel

# Terminal and editor
sudo pacman -S tmux vim

# Fonts (for Waybar icons and UI)
sudo pacman -S ttf-font-awesome ttf-jetbrains-mono-nerd
```

### Optional Dependencies

```bash
# For Waybar modules
sudo pacman -S brightnessctl bluez bluez-utils network-manager-applet

# Audio control
sudo pacman -S pavucontrol wireplumber pipewire
```

## Installation

### Using Nix Home Manager (Recommended)

This is the recommended method for reproducible, declarative environment management.

1. **Install Nix** (if not already installed):

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. **Enable flakes:**

Add to `~/.config/nix/nix.conf` (create if it doesn't exist):
```
experimental-features = nix-command flakes
```

Or system-wide in `/etc/nix/nix.conf` (requires sudo).

3. **Clone and activate:**

```bash
git clone https://github.com/vasumv/dotfiles ~/dotfiles
cd ~/dotfiles
# Use -b backup to automatically back up existing config files
nix run home-manager/master -- switch --flake .#vasu -b backup
```

This will:
- Install all required packages (Hyprland, Waybar, fonts, etc.)
- Create symbolic links for all configuration files
- Automatically back up any existing config files with `.backup` extension
- Set up your entire environment in one command

4. **Update after making changes:**

```bash
cd ~/dotfiles
home-manager switch --flake .#vasu
```

**Note:** The `-b backup` flag is only needed for first-time installation when you have existing config files.

### Manual Installation (Legacy)

If you prefer not to use Nix:

1. **Clone the repository:**

```bash
git clone https://github.com/vasumv/dotfiles ~/dotfiles
cd ~/dotfiles
```

2. **Install dependencies manually:**

```bash
# On Arch Linux
sudo pacman -S hyprland hyprpaper hyprlock waybar fuzzel tmux vim \
               kitty dolphin brightnessctl playerctl \
               pipewire wireplumber pavucontrol \
               ttf-font-awesome ttf-jetbrains-mono-nerd \
               network-manager-applet
```

3. **Run the setup script:**

```bash
chmod +x setup.sh
./setup.sh
```

The setup script will:
- Create symbolic links from this repository to your home directory
- Create necessary config directories if they don't exist
- Link all configuration files to their appropriate locations

## What Gets Linked

The setup script creates the following symlinks:

### Tmux
- `~/.tmux.conf` → `tmux/tmux.conf`

### Vim
- `~/.vimrc.local` → `vim/vimrc.local`
- `~/.vimrc.bundles.local` → `vim/vimrc.bundles.local`

### Hyprland
- `~/.config/hypr/hyprland.conf` → `hyprland/hyprland.conf`
- `~/.config/hypr/hyprpaper.conf` → `hyprland/hyprpaper.conf`
- `~/.config/hypr/hyprlock.conf` → `hyprland/hyprlock.conf`

### Waybar
- `~/.config/waybar/config` → `hyprland/waybar/config`
- `~/.config/waybar/config.jsonc` → `hyprland/waybar/config.jsonc`
- `~/.config/waybar/style.css` → `hyprland/waybar/style.css`
- `~/.config/waybar/README.md` → `hyprland/waybar/README.md`

### Fuzzel
- `~/.config/fuzzel/fuzzel.ini` → `hyprland/fuzzel/fuzzel.ini`

### Wallpapers
- `~/Pictures/wallpapers/spire.png` → `hyprland/wallpapers/spire.png`
- `~/Pictures/wallpapers/spire2.png` → `hyprland/wallpapers/spire2.png`

## Post-Installation

### First Time Setup

1. **Start Hyprland:**
   - Log out and select Hyprland from your display manager
   - Or run `Hyprland` from a TTY

2. **Verify everything works:**
   - Waybar should appear at the top of your screen
   - Wallpaper should be set via hyprpaper
   - Try opening Fuzzel (usually Super+D or check keybindings)

3. **Review keybindings:**
   - Check `hyprland/hyprland.conf` for custom keybindings
   - Default Super key bindings should be configured

## Updating

### With Nix Home Manager

To update your configurations:

```bash
cd ~/dotfiles
git pull
home-manager switch --flake .#vasu
```

To add new packages, edit `home.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  neofetch  # Add your package here
];
```

Then run `home-manager switch --flake .#vasu`.

**Important:** Some packages have specific naming conventions in Nix:
- KDE apps: `kdePackages.dolphin` (not `dolphin`)
- Nerd fonts: `nerd-fonts.jetbrains-mono` (not `nerdfonts.override`)
- Unfree software (like Slack): Requires `nixpkgs.config.allowUnfree = true` in `home.nix`

### With Manual Installation

```bash
cd ~/dotfiles
git pull
./setup.sh  # Re-run to update symlinks if needed
```

Since the files are symlinked, any changes you make to files in `~/.config/` will automatically update the files in this repository. Remember to commit your changes:

```bash
cd ~/dotfiles
git add .
git commit -m "Update configuration"
git push
```

## Rollback (Nix Only)

One of the benefits of Home Manager is easy rollback:

```bash
# List all generations
home-manager generations

# Rollback to a specific generation
home-manager switch --switch-generation <number>
```

## Troubleshooting

### Waybar not showing
- Check if Waybar is running: `pgrep waybar`
- Restart Waybar: `killall waybar && waybar &`

### Wallpaper not loading
- Verify hyprpaper is running: `pgrep hyprpaper`
- Check wallpaper paths in `hyprland/hyprpaper.conf`

### Permission issues
- Ensure setup.sh is executable: `chmod +x setup.sh`

## Customization

Feel free to modify any configuration files to suit your preferences. Key files to customize:

- **Hyprland keybindings**: `hyprland/hyprland.conf`
- **Waybar appearance**: `hyprland/waybar/style.css`
- **Waybar modules**: `hyprland/waybar/config`
- **Tmux keybindings**: `tmux/tmux.conf`
- **Vim settings**: `vim/vimrc.local`

## License

Personal dotfiles - use at your own discretion.
