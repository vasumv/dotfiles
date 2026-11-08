# Dotfiles

Personal configuration files for a Hyprland desktop on Arch Linux.

## Overview

This repository contains configuration files for:
- **Hyprland**: Wayland compositor
- **Waybar**: Status bar for Hyprland
- **Hyprpaper**: Wallpaper utility
- **Hyprlock**: Screen locker
- **Fuzzel**: Application launcher
- **Gammastep**: Night color temperature
- **Fish**: Shell
- **Tmux**: Terminal multiplexer
- **Vim**: Text editor

## How This Setup Works

The setup uses two package managers, and they do different jobs:

- **pacman** provides the desktop. GDM starts Hyprland from `/usr/bin` with `PATH=/usr/local/bin:/usr/bin`, so everything launched from `hyprland.conf` has to be installed through pacman or the AUR.
- **Nix Home Manager** provides config symlinks, fish, zoxide and tools used from a terminal.

`home.nix` also installs Hyprland, Waybar, kitty and others, but the session doesn't use those copies. They do not replace the pacman packages:
- Nix's kitty crashes on this Arch install with an EGL error, because it can't initialize graphics without a wrapper such as nixGL.
- Nix's hyprlock uses its own PAM build, which is missing modules that Arch's PAM config references, such as `pam_systemd_home.so`. Don't rely on it as a screen locker.

## Branches

`sd` is the current branch for this laptop. `master` and `cmu-desktop` have diverged from it and are missing recent changes, including the volume script and gammastep config.

## Setting Up a New Laptop

These steps are based on the current laptop and haven't been tested on a fresh install. Use the username `vasu`, because `/home/vasu` is hard-coded in `home.nix` and `hyprland.conf`.

1. **Install packages:**

```bash
sudo pacman -S gdm hyprland hyprpaper hyprlock waybar fuzzel wofi kitty fish tmux gvim \
  grim slurp wl-clipboard gammastep brightnessctl playerctl libnotify \
  networkmanager network-manager-applet bluez bluez-utils blueman \
  pipewire pipewire-pulse wireplumber xdg-desktop-portal-hyprland \
  ttf-jetbrains-mono-nerd woff2-font-awesome \
  swaync dolphin pavucontrol
```

Then install `hyprshot` and `slack-desktop`, using an AUR helper for anything pacman doesn't have. The current laptop runs `hyprland-git` from the AUR, so plain `hyprland` will be a different version.

2. **Enable services and set your shell:**

```bash
sudo systemctl enable gdm NetworkManager bluetooth
chsh -s /usr/bin/fish
```

3. **Install Nix:**

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

4. **Enable flakes** by adding this to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

5. **Clone and activate:**

```bash
git clone -b sd https://github.com/vasumv/dotfiles ~/dotfiles
cd ~/dotfiles
# Use -b backup to automatically back up existing config files
nix run home-manager/master -- switch --flake .#vasu -b backup
```

`home-manager/master` is the latest version, while `flake.lock` pins packages from October 2025, so this step may need `nix flake update` first.

6. **Update machine-specific settings:**
   - Monitors: the `monitor =` lines in `hyprland/hyprland.conf`
   - Wallpaper output: the `wallpaper =` lines in `hyprland/hyprpaper.conf`
   - Gammastep location: the `gammastep` line in `hyprland/hyprland.conf`

7. **Reboot** and choose Hyprland at the GDM login screen.

## Known Issues on the Current Laptop

These commands are only installed through Nix here, so the Hyprland session can't find them:
- `swaync`: isn't running, so there is no notification daemon
- `hyprshot`: the screenshot keybindings that use it can't find it
- `dolphin`: the file manager keybinding can't find it
- `pavucontrol`: works from a terminal, but not when launched from the session

Installing them through pacman or the AUR fixes this.

## What Gets Linked

Home Manager creates these symlinks, defined in `home.nix`:

- `~/.tmux.conf` → `tmux/tmux.conf`
- `~/.vimrc.local` → `vim/vimrc.local`
- `~/.vimrc.bundles.local` → `vim/vimrc.bundles.local`
- `~/.config/hypr/hyprland.conf` → `hyprland/hyprland.conf`
- `~/.config/hypr/hyprpaper.conf` → `hyprland/hyprpaper.conf`
- `~/.config/hypr/hyprlock.conf` → `hyprland/hyprlock.conf`
- `~/.config/waybar` → `hyprland/waybar`
- `~/.config/fuzzel/fuzzel.ini` → `hyprland/fuzzel/fuzzel.ini`
- `~/.config/gammastep/config.ini` → `hyprland/gammastep/config.ini`
- `~/Pictures/wallpapers/spire.png` → `hyprland/wallpapers/spire.png`
- `~/Pictures/wallpapers/spire2.png` → `hyprland/wallpapers/spire2.png`

The links resolve to this repository, so edits take effect without a rebuild and show up in `git status`.

Fish config is generated from `programs.fish` in `home.nix`.

`setup.sh` is the older way to create these links without Home Manager. It also links `fish/config.fish`.

## Keybindings

All keybindings are in `hyprland/hyprland.conf`. The launcher is Super+Space.

## Updating

To apply changes to `home.nix`:

```bash
cd ~/dotfiles
home-manager switch --flake .#vasu
```

The `-b backup` flag is only needed when existing files are in the way.

To add a tool for use in a terminal, add it to `home.packages` in `home.nix`. To add something the desktop launches, install it through pacman.

**Important:** Some packages have specific naming conventions in Nix:
- KDE apps: `kdePackages.dolphin` (not `dolphin`)
- Nerd fonts: `nerd-fonts.jetbrains-mono` (not `nerdfonts.override`)
- Unfree software (like Slack): Requires `nixpkgs.config.allowUnfree = true` in `home.nix`

## Rollback

Home Manager generations cover the Nix side only, not pacman packages:

```bash
# List all generations
home-manager generations

# Rollback to a specific generation
home-manager switch --switch-generation <number>
```

## Troubleshooting

### A keybinding or autostart app does nothing
- Check that the session can find it: `PATH=/usr/local/bin:/usr/bin command -v <name>`
- If nothing prints, install it through pacman

### Waybar not showing
- Check if Waybar is running: `pgrep waybar`
- Restart Waybar: `killall waybar && waybar &`

### Wallpaper not loading
- Verify hyprpaper is running: `pgrep hyprpaper`
- Check wallpaper paths in `hyprland/hyprpaper.conf`

### Screen color not changing
- Check that gammastep is running: `pgrep gammastep`
- Print the current period and temperature: `gammastep -p -m dummy -l 32.68:-117.18`
- The tint only applies at night. Set `temp-night` in `hyprland/gammastep/config.ini`, then restart gammastep

## Customization

Key files to customize:

- **Hyprland keybindings**: `hyprland/hyprland.conf`
- **Waybar appearance**: `hyprland/waybar/style.css`
- **Waybar modules**: `hyprland/waybar/config.jsonc`
- **Night temperature**: `hyprland/gammastep/config.ini`
- **Tmux keybindings**: `tmux/tmux.conf`
- **Vim settings**: `vim/vimrc.local`

## License

Personal dotfiles - use at your own discretion.
