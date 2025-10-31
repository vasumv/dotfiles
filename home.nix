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
    hyprshot
    waybar
    fuzzel

    # Screenshot dependencies
    # grim      # Screenshot utility for Wayland
    # slurp     # Select a region in Wayland
    # jq        # JSON processor
    wl-clipboard

    # Notifications
    swaynotificationcenter  # Notification daemon for Wayland with notification center
    libnotify              # For notify-send command

    # Terminal and tools
    kitty
    kdePackages.dolphin  # Qt6-based Dolphin file manager
    fish
    tmux
    vim-full
    silver-searcher

    # System utilities
    brightnessctl
    playerctl
    networkmanagerapplet
    networkmanager-openconnect

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

  home.file = {
    # --- Hyprland configurations (live symlinks) ---
    ".config/hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/hyprland.conf";

    ".config/hypr/hyprpaper.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/hyprpaper.conf";

    ".config/hypr/hyprlock.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/hyprlock.conf";

    # --- Waybar configuration (directory symlink, reloads instantly) ---
    ".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/waybar";

    # --- Fuzzel configuration ---
    ".config/fuzzel/fuzzel.ini".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/fuzzel/fuzzel.ini";

    # --- Wallpapers (still fine to copy, they don’t change often) ---

    # Wallpapers
    "Pictures/wallpapers/spire.png".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/wallpapers/spire.png";

    "Pictures/wallpapers/spire2.png".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/hyprland/wallpapers/spire2.png";

    # --- Tmux configuration ---
    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/tmux/tmux.conf";

    # --- Vim configurations ---
    ".vimrc.local".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/vim/vimrc.local";
    ".vimrc.bundles.local".source =
      config.lib.file.mkOutOfStoreSymlink "/home/vasu/dotfiles/vim/vimrc.bundles.local";
  };


  # Optional: Enable some useful programs with Home Manager modules
  programs.git = {
    enable = true;
    userName = "Vasu Vikram";
    userEmail = "vvikram@andrew.cmu.edu";
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
    shellAliases = {
      ll = "ls -la";
      ta = "tmux a -t";
    };
  };

  # Zoxide - smarter cd command that learns your habits
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd c" ];
    # Use 'c' to jump to directories
    # e.g., "c dotfiles" will jump to ~/dotfiles after you've visited it
    # 'ci' for interactive selection
  };

  programs.bash = {
    enable = true;
    # Add any bash customizations here
  };
}
