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
    HYPRCURSOR_SIZE = "36";
    # Fallback para apps XWayland
    XCURSOR_THEME = "Chiharu";
    XCURSOR_SIZE = "36";
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
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "hyprcursor-setup" ''
        # Wait for Hyprland to be ready
        sleep 3
        
        # Set cursor via hyprctl (método oficial)
        ${pkgs.hyprland}/bin/hyprctl setcursor Chiharu 36
        
        # Para apps GTK (fallback)
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'Chiharu'
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-size 36
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
