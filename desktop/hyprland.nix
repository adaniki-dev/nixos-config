{ config, lib, pkgs, ... }:

{
  # Habilitar Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };

  # Pacotes de sistema
  environment.systemPackages = with pkgs; [
    hyprland hyprpaper hyprlock hypridle hyprpicker

    waybar wttrbar cava
    wl-clipboard cliphist
    rofi-wayland dunst libnotify
    ranger wlogout
    swww pywal wpgtk
    brightnessctl blueman
    playerctl pamixer
    polkit_gnome
    qt5.qtwayland qt6.qtwayland libsForQt5.qt5ct qt6Packages.qt6ct
    xdg-utils xdg-desktop-portal-hyprland

    # Fontes
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "VictorMono" ]; })
    font-awesome

    # Temas
    catppuccin-gtk tela-icon-theme bibata-cursors

    # Utils
    zoxide fzf eza bat
    openssl cbonsai tree
  ];

  # Variáveis globais
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    MOZ_ENABLE_WAYLAND = "1";
    CLUTTER_BACKEND = "wayland";
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  # XDG Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Polkit
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Fontes padrão
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
