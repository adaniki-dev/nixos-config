{ config, lib, pkgs, ... }:

{
  # Habilitar Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Desabilitar GDM se estiver habilitado
  services.xserver.displayManager.gdm.enable = lib.mkForce false;
  
  # Habilitar SDDM para Hyprland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Pacotes essenciais para Hyprland
  environment.systemPackages = with pkgs; [
    # Window Manager e utilitários
    hyprland
    hyprpaper
    hyprlock
    hypridle
    
    # Screenshot e clipboard
    grimblast
    slurp
    grim
    wl-clipboard
    
    # Terminal e aplicações básicas
    alacritty
    kitty
    
    # File manager
    nautilus
    
    # Browser
    firefox
    
    # App launcher
    rofi-wayland
    
    # Notifications
    dunst
    libnotify
    
    # Audio e brightness controls
    brightnessctl
    playerctl
    pamixer
    
    # Network manager applet
    networkmanagerapplet
    
    # Bluetooth
    blueberry
    
    # System monitor
    btop
    
    # Waybar para status bar
    waybar
    
    # Themes e ícones
    adwaita-icon-theme
    gnome-themes-extra
    
    # Wallpaper engine
    swww
    
    # Qt/GTK compatibility
    qt5.qtwayland
    qt6.qtwayland
    
    # XDG utilities
    xdg-utils
    xdg-desktop-portal-hyprland
    
    # Polkit agent
    polkit_gnome
  ];

  # Variáveis de ambiente para Wayland
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    
    # Qt
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # Mozilla
    MOZ_ENABLE_WAYLAND = "1";
    
    # Cursor
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Adwaita";
  };

  # XDG Desktop Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Habilitar polkit
  security.polkit.enable = true;
  
  # Polkit agent
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

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];
}