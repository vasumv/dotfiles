# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for a Wayland-based Linux development environment using Hyprland as the window manager. Configurations are managed declaratively via Nix Home Manager, which handles both package installation and dotfile symlinking.

## Setup and Installation

### Nix Home Manager (Recommended)

This repository uses Nix flakes and Home Manager for reproducible, declarative configuration management.

**First-time setup on a new machine:**

1. **Install Nix** (if not already installed):
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

2. **Enable flakes** (add to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):
```
experimental-features = nix-command flakes
```

3. **Clone dotfiles and activate:**
```bash
git clone https://github.com/vasumv/dotfiles ~/dotfiles
cd ~/dotfiles
nix run home-manager/master -- switch --flake .#vasu
```

**Update configuration after changes:**
```bash
cd ~/dotfiles
home-manager switch --flake .#vasu
```

**Rollback to previous generation:**
```bash
home-manager generations  # List all generations
home-manager switch --switch-generation <number>
```

### Legacy Setup (setup.sh)

The old `setup.sh` script is kept for manual installations without Nix:
```bash
./setup.sh
```

The setup script creates symlinks from this repo to `~/.config/` and `~/` locations. Since files are symlinked, any edits to files in `~/.config/` automatically update this repository.

## Configuration Architecture

### Nix Files

**`flake.nix`:**
- Defines Nix flake inputs (nixpkgs, home-manager)
- Declares the `vasu` home configuration
- Uses nixos-unstable channel for latest packages

**`home.nix`:**
- Declares all packages to install (`home.packages`)
- Manages dotfile symlinks via `home.file`
- Single source of truth for the entire environment
- When modifying this file, run `home-manager switch --flake .#vasu` to apply changes

### Symlink Structure
Configs are symlinked by Home Manager (defined in `home.nix`):
- `tmux/tmux.conf` → `~/.tmux.conf`
- `vim/vimrc.local` → `~/.vimrc.local`
- `vim/vimrc.bundles.local` → `~/.vimrc.bundles.local`
- `hyprland/*.conf` → `~/.config/hypr/*.conf`
- `hyprland/waybar/*` → `~/.config/waybar/*`
- `hyprland/fuzzel/fuzzel.ini` → `~/.config/fuzzel/fuzzel.ini`
- `hyprland/wallpapers/*` → `~/Pictures/wallpapers/*`

**Note:** With Home Manager, symlinks are managed declaratively. Don't manually create/delete symlinks; update `home.nix` instead.

### Hyprland Configuration (`hyprland/hyprland.conf`)

**Display Setup:**
- Primary monitor: `eDP-1` at 2560x1440@60Hz with 1.6 scale factor
- Multi-monitor support via `Super+r` (right) and `Super+w` (left) focus switching

**Key Programs:**
- Terminal: `kitty`
- File Manager: `dolphin`
- Application Launcher: `fuzzel`

**Autostart:**
The config uses `exec` (not `exec-once`) for waybar, hyprpaper, and nm-applet to restart them on every config reload. This ensures they pick up config changes.

**Input Configuration:**
- Keyboard: US layout with `caps:super` (Caps Lock mapped to Super)
- Key repeat: rate=50, delay=200ms
- Touchpad: Natural scrolling enabled
- Three-finger horizontal gesture for workspace switching

**Visual Settings:**
- Layout: Dwindle with 5px inner gaps, 20px outer gaps
- Borders: 2px, animated gradient (cyan to green at 45deg)
- Rounded corners: 10px
- Blur enabled on background elements

**Critical Keybindings** (Super = Windows key):
- `Super+Q`: Terminal
- `Super+E`: File manager
- `Super+Space`: Fuzzel launcher
- `Super+C`: Kill active window
- `Super+V`: Toggle floating
- `Super+h/j/k/l`: Move focus (vim-style navigation)
- `Super+1-9,0`: Switch to workspace
- `Super+Shift+1-9,0`: Move window to workspace
- `Super+r/w`: Focus right/left monitor
- `Super+S`: Toggle scratchpad
- `Super+Shift+K`: Lock screen and suspend
- `XF86Audio*`: Volume/brightness/media controls (requires `wpctl`, `brightnessctl`, `playerctl`)

### Waybar Configuration (`hyprland/waybar/`)

**Module Layout:**
- Left: Arch icon, clock, CPU, memory, disk, temperature
- Center: Workspace indicators (Hyprland workspaces)
- Right: Taskbar, idle inhibitor, volume slider, volume, network, language switcher

**Configuration Files:**
- `config.jsonc`: Module definitions and behavior
- `style.css`: Catppuccin-themed styling (133 lines)

**Localization:**
- Timezone: `America/Mexico_City`
- Language switcher: Spanish (ESP) ↔ English (ENG)
- Some tooltips are in Spanish (e.g., "Uso de CPU", "RAM en uso")

**Behavior:**
- Autohide enabled (shows on hover)
- Taskbar: Click to activate, middle-click to close

**Restart Waybar:**
```bash
pkill waybar && waybar &
```

### Tmux Configuration (`tmux/tmux.conf`)

**Key Changes from Defaults:**
- Prefix: `Ctrl+A` (not `Ctrl+B`)
- Pane navigation: `Alt+h/j/k/l` (no prefix needed)
- Pane splitting: `\` (horizontal), `-` (vertical)
- Window navigation: `Ctrl+h/l`
- Pane resize: `Shift+h/j/k/l`
- Vi-mode enabled for copy mode

### Vim Configuration (`vim/vimrc.local`)

**Key Settings:**
- Colorscheme: Molokai (dark background)
- Indentation: 2 spaces for most filetypes
- Clipboard: `unnamedplus` (system clipboard integration)
- F1 remapped to Escape
- NERDTree auto-close on file open

### Fish Shell Configuration (`fish/config.fish`)

**HiDPI Scaling Settings:**
The fish config sets critical environment variables for HiDPI displays:
- `GDK_SCALE=1`, `GDK_DPI_SCALE=0.5`: GTK application scaling
- `QT_AUTO_SCREEN_SCALE_FACTOR=1`, `QT_SCALE_FACTOR=1`: Qt application scaling

These settings work with the Hyprland monitor scale factor (1.6) to provide proper scaling for applications on high-resolution displays.

**Note:** In `home.nix`, fish configuration is managed via `programs.fish.shellInit` instead of a separate file. This allows Home Manager to generate the config.fish file automatically.

## Theming

**Color Scheme:** Catppuccin (used in Fuzzel and Waybar)
**Fonts:** JetBrains Mono / JetBrains Mono Nerd Font (required for icons)

## Testing Configuration Changes

**Test Hyprland config without restarting:**
```bash
# Reload Hyprland config
hyprctl reload
```

**Test Waybar changes:**
```bash
pkill waybar && waybar &
```

**Test wallpaper changes:**
```bash
pkill hyprpaper && hyprpaper &
```

## Common Modifications

**Adding keybindings:** Edit `hyprland/hyprland.conf` line 235+ (keybindings section)
**Adjusting Waybar modules:** Edit `hyprland/waybar/config.jsonc`
**Changing Waybar appearance:** Edit `hyprland/waybar/style.css`
**Monitor configuration:** Edit monitor line in `hyprland/hyprland.conf` (currently line 26)

## Package Management

### Adding New Packages
To add a new package, edit `home.nix`:
```nix
home.packages = with pkgs; [
  # ... existing packages
  neofetch  # Add new package here
];
```

Then apply: `home-manager switch --flake .#vasu`

### Adding New Dotfiles
To manage a new config file, add to `home.file` in `home.nix`:
```nix
home.file.".config/myapp/config".source = ./myapp/config;
```

## Important Notes

- The Hyprland config has `autogenerated = 0` (line 7) to suppress the autogenerated config warning
- Waybar uses `gtk-layer-shell = true` for proper Wayland integration
- Lock screen (`hyprlock`) is triggered via `Super+Shift+K` which also suspends the system
- Files edited in `~/.config/` are automatically changed in this repo due to symlinks—commit changes from `~/dotfiles`
- All packages and dependencies are declared in `home.nix`—this is the single source of truth for the environment
- Home Manager creates generations on each switch, allowing easy rollback
