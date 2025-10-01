{ config, pkgs, lib, inputs, ... }:

{
  # Home Manager settings for the user "nikoster"
  home.stateVersion = "25.05"; # Set to the current NixOS version.

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "nikoster";
  home.homeDirectory = "/home/nikoster";

  # Add user-specific packages here.
  home.packages = with pkgs; [
    # Browsers
    brave
    inputs.zen-browser.packages."${system}".default

    # Communication
    element-desktop
    fractal
    telegram-desktop

    # Development & Utilities
    direnv
    ruff # For Python linting and formatting in Zed
    pyright # For Python type checking in Zed
    poetry # For Python dependency management
    nodejs # Required by some language servers
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Oh My Zsh configuration is a separate module
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "git"
      "z"
      "sudo"
      "colored-man-pages"
      "command-not-found"
    ];
  };

  # Zed Editor Configuration for Python Development
  programs.zed-editor = {
    enable = true;
  };

  # dconf settings for GNOME managed by Home Manager
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        caffeine.extensionUuid
        clipboard-history.extensionUuid
        smart-auto-move-ng.extensionUuid
        arcmenu.extensionUuid
        just-perfection.extensionUuid
        user-themes.extensionUuid
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
