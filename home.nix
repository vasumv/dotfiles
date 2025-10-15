{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "vasu";
  home.homeDirectory = "/home/vasu";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  # Allow unfree packages (like Slack)
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    # Hyprland ecosystem
    hyprland
    hyprpaper
    hyprlock
    waybar
    fuzzel

    # Terminal and tools
    kitty
    kdePackages.dolphin  # Qt6-based Dolphin file manager
    fish
    tmux
    vim

    # System utilities
    brightnessctl
    playerctl
    networkmanagerapplet

    # Audio
    pipewire
    wireplumber
    pavucontrol

    # Fonts (critical for Waybar icons)
    font-awesome
    nerd-fonts.jetbrains-mono

    # Additional tools referenced in configs
    slack
  ];

  # Symlink dotfiles to their proper locations
  home.file = {
    # Hyprland configurations
    ".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprland/hyprpaper.conf;
    ".config/hypr/hyprlock.conf".source = ./hyprland/hyprlock.conf;

    # Waybar configurations
    ".config/waybar/config.jsonc".source = ./hyprland/waybar/config.jsonc;
    ".config/waybar/style.css".source = ./hyprland/waybar/style.css;
    ".config/waybar/README.md".source = ./hyprland/waybar/README.md;

    # Fuzzel configuration
    ".config/fuzzel/fuzzel.ini".source = ./hyprland/fuzzel/fuzzel.ini;

    # Wallpapers
    "Pictures/wallpapers/spire.png".source = ./hyprland/wallpapers/spire.png;
    "Pictures/wallpapers/spire2.png".source = ./hyprland/wallpapers/spire2.png;

    # Tmux configuration
    ".tmux.conf".source = ./tmux/tmux.conf;

    # Vim configurations
    ".vimrc.local".source = ./vim/vimrc.local;
    ".vimrc.bundles.local".source = ./vim/vimrc.bundles.local;
  };

  # Optional: Enable some useful programs with Home Manager modules
  programs.git = {
    enable = true;
    # Uncomment and customize if you want Home Manager to manage git config:
    # userName = "Your Name";
    # userEmail = "your.email@example.com";
  };

  programs.fish = {
    enable = true;

    # HiDPI scaling settings for GTK and Qt applications
    shellInit = ''
      set -x GDK_SCALE 1
      set -x GDK_DPI_SCALE 0.5
      set -x QT_AUTO_SCREEN_SCALE_FACTOR 1
      set -x QT_SCALE_FACTOR 1
    '';

    # You can add more fish config here:
    # interactiveShellInit = ''
    #   # Fish-specific interactive commands
    # '';
    # shellAliases = {
    #   ll = "ls -la";
    # };
  };

  programs.bash = {
    enable = true;
    # Add any bash customizations here
  };
}
