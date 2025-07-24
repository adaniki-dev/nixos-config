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
    # Hyprland core - IMPORTANTE: hyprcursor para suporte nativo
    hyprland hyprpaper hyprlock hypridle hyprpicker hyprcursor
    adwaita-icon-theme
    gnome-themes-extra
    xorg.xrdb
    # Resto dos seus pacotes...
    alacritty kitty fish
    fishPlugins.tide fishPlugins.done fishPlugins.fzf-fish
    fishPlugins.forgit fishPlugins.hydro fishPlugins.grc grc
    waybar wttrbar cava nwg-look
    grimblast slurp grim wl-clipboard cliphist hyprshot
    rofi-wayland dunst libnotify
    nautilus kdePackages.dolphin ranger
    firefox google-chrome
    mpv pavucontrol playerctl pamixer
    brightnessctl blueman networkmanagerapplet
    vscode neovim gh
    swww pywal wpgtk
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.victor-mono
    font-awesome
    btop htop neofetch pfetch tree cbonsai
    catppuccin-gtk tela-icon-theme bibata-cursors
    catppuccin-sddm
    hyprlock
    wlogout
    polkit_gnome
    xdg-utils
    qt5.qtwayland qt6.qtwayland
    libsForQt5.qt5ct qt6Packages.qt6ct
    gsettings-desktop-schemas
    glib
    openssl zoxide fzf eza bat
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


