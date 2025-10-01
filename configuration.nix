# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = { allowUnfree = true; };
  };
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      http-connections = 50;
      warn-dirty = false;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bigdickinlaptop"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the GNOME Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    variant = ",";
    options = "grp:win_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.nikoster = {
    isNormalUser = true;
    description = "nikoster";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages can be defined here if needed.
  # User applications are now in home.nix
  environment.systemPackages = with pkgs; [
    # Development & Utilities
    nano
    wget
    curl
    git
    gcc
    python313
    dialog
    freerdp
    iproute2
    libnotify
    netcat-openbsd
    neovim

    # GNOME Apps & Tweaks
    gedit
    nautilus
    gnome-terminal
    gnome-tweaks
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-history
    gnomeExtensions.smart-auto-move-ng
    gnomeExtensions.arcmenu
    gnomeExtensions.just-perfection
    gnomeExtensions.user-themes
  ];

  # Z shell setup for the system
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.nekoray.enable = true;
  programs.nekoray.tunMode.enable = true;

  programs.dconf.enable = true;

  # Enable MIME
  xdg.mime.enable = true;

  # Enable GPU acceleration
  hardware.graphics.enable = true;

  # NVIDIA proprietary drivers setup
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = pkgsUnstable.linuxPackages.nvidiaPackages.stable;
  };
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  
  #Docker enable
  virtualisation.docker.enable = true;
  
  # Trash directory service for nautilus
  services.gvfs.enable = true;

  system.stateVersion = "25.05";
}
