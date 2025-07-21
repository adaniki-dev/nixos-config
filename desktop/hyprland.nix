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
    # Hyprland core
    hyprland hyprpaper hyprlock hypridle hyprpicker

    # Terminal & shell
    alacritty kitty fish
    fishPlugins.tide fishPlugins.done fishPlugins.fzf-fish
    fishPlugins.forgit fishPlugins.hydro fishPlugins.grc grc

    # Waybar & visual
    waybar wttrbar cava

    # Screenshot & clipboard
    grimblast slurp grim wl-clipboard cliphist

    # Launchers & notificações
    rofi-wayland dunst libnotify

    # File managers
    nautilus kdePackages.dolphin ranger

    # Navegadores
    firefox google-chrome

    # Mídia
    mpv pavucontrol playerctl pamixer

    # Utilitários do sistema
    brightnessctl blueman networkmanagerapplet

    # Dev
    vscode neovim gh

    # Wallpapers & temas
    swww pywal wpgtk

    # Fonts (corrigido)
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.victor-mono
    font-awesome

    # Utils
    btop htop neofetch pfetch tree cbonsai

    # Temas e ícones
    catppuccin-gtk tela-icon-theme bibata-cursors

    # Power menu
    wlogout

    # Polkit
    polkit_gnome

    # XDG e portal
    xdg-utils xdg-desktop-portal-hyprland

    # GTK/Qt
    qt5.qtwayland qt6.qtwayland
    libsForQt5.qt5ct qt6Packages.qt6ct

    # Outros
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
    XCURSOR_SIZE = "24";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
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
