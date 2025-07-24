{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };



  environment.systemPackages = with pkgs; [
    # ============================================================================
    # HYPRLAND CORE & WAYLAND ESSENTIALS
    # ============================================================================
    hyprland
    hyprpaper      # Wallpaper manager
    hyprlock       # Screen locker
    hypridle       # Idle daemon
    hyprpicker     # Color picker
    hyprcursor     # Cursor theme support
    
    # ============================================================================
    # SYSTEM THEMES & ICONS
    # ============================================================================
    adwaita-icon-theme
    gnome-themes-extra
    xorg.xrdb      # X resources database
    
    # ============================================================================
    # TERMINAL & SHELL
    # ============================================================================
    alacritty
    kitty
    fish
    # Fish plugins
    fishPlugins.tide
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    grc            # Generic colouriser
    
    # ============================================================================
    # WAYLAND UI & SYSTEM BAR
    # ============================================================================
    waybar         # Status bar
    wttrbar        # Weather bar
    cava           # Audio visualizer
    nwg-look       # GTK settings
    
    # ============================================================================
    # SCREENSHOT & CLIPBOARD
    # ============================================================================
    grimblast      # Screenshot utility
    slurp          # Area selection
    grim           # Screenshot
    wl-clipboard   # Wayland clipboard
    cliphist       # Clipboard history
    hyprshot       # Hyprland screenshot tool
    
    # ============================================================================
    # LAUNCHER & NOTIFICATIONS
    # ============================================================================
    rofi-wayland   # Application launcher
    dunst          # Notification daemon
    libnotify      # Notification library
    
    # ============================================================================
    # FILE MANAGERS
    # ============================================================================
    nautilus
    kdePackages.dolphin
    ranger         # Terminal file manager
    
    # ============================================================================
    # WEB BROWSERS
    # ============================================================================
    firefox
    google-chrome
    
    # ============================================================================
    # MULTIMEDIA
    # ============================================================================
    mpv            # Media player
    pavucontrol    # PulseAudio volume control
    playerctl      # Media player control
    pamixer        # Audio mixer
    
    # ============================================================================
    # HARDWARE CONTROL
    # ============================================================================
    brightnessctl  # Brightness control
    blueman        # Bluetooth manager
    networkmanagerapplet  # Network manager GUI
    
    # ============================================================================
    # DEVELOPMENT TOOLS
    # ============================================================================
    vscode
    neovim
    gh             # GitHub CLI
    
    # ============================================================================
    # WALLPAPER & THEMING
    # ============================================================================
    swww           # Wayland wallpaper daemon
    pywal          # Color scheme generator
    wpgtk          # Wallpaper and theme manager
    
    # ============================================================================
    # FONTS
    # ============================================================================
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.victor-mono
    font-awesome
    
    # ============================================================================
    # SYSTEM MONITORING
    # ============================================================================
    btop           # Resource monitor
    htop           # Process viewer
    neofetch       # System info
    pfetch         # Minimal system info
    tree           # Directory tree
    cbonsai        # Bonsai tree in terminal
    
    # ============================================================================
    # THEMES & CURSORS
    # ============================================================================
    catppuccin-gtk
    tela-icon-theme
    bibata-cursors
    catppuccin-sddm
    
    # ============================================================================
    # SESSION & SECURITY
    # ============================================================================
    wlogout        # Logout menu
    polkit_gnome   # Authentication agent
    xdg-utils      # XDG utilities
    
    # ============================================================================
    # QT SUPPORT & LIBRARIES
    # ============================================================================
    kdePackages.sddm
    qt5.qtwayland
    qt6.qtwayland
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    qt6Packages.qtsvg
    qt6Packages.qtdeclarative
    qt6Packages.qt5compat
    
    # ============================================================================
    # DESKTOP INTEGRATION
    # ============================================================================
    gsettings-desktop-schemas
    glib
    
    # ============================================================================
    # CLI UTILITIES
    # ============================================================================
    openssl
    zoxide         # Smart directory jumper
    fzf            # Fuzzy finder
    eza            # Modern ls replacement
    bat            # Cat with syntax highlighting
  ];

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
    # Configurações de cursor conforme documentação
    HYPRCURSOR_THEME = "Chiharu";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "Chiharu";
    XCURSOR_SIZE = "24";
    LC_ALL = "pt_BR.UTF-8";
    LC_CTYPE = "pt_BR.UTF-8";
    LANG = "pt_BR.UTF-8";
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_VARIANT = "intl";
    XKB_DEFAULT_OPTIONS = "compose:ralt";
  };

  # Resto da configuração...
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

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

  # Serviço simplificado baseado na documentação
systemd.user.services.hyprcursor-setup = {
  description = "Setup Hyprcursor theme and size";
  wantedBy = [ "hyprland-session.target" ];
  after = [ "hyprland-session.target" ];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    ExecStart = pkgs.writeShellScript "hyprcursor-setup" ''
      # Wait for Hyprland to be fully ready
      sleep 5
      
      # Set cursor via hyprctl
      ${pkgs.hyprland}/bin/hyprctl setcursor Chiharu-Wayland 24
      
      # Para apps GTK
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'Chiharu-Wayland'
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size 24
      
      # Para Qt apps
      echo "Xcursor.theme: Chiharu-Wayland" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
      echo "Xcursor.size: 24" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
    '';
  };
};

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji liberation_ttf
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.victor-mono
      font-awesome
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}


