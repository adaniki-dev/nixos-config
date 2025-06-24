{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hyprland e utilitários
    hyprland hyprpaper hyprlock
    grimblast slurp grim wl-clipboard

    # Aplicativos essenciais
    alacritty xfce.thunar firefox
    rofi-wayland dunst

    # Multimídia e controle
    blueberry brightnessctl playerctl pamixer
    galculator qjournalctl

    # Outros
    xdg-utils
    qt5.qtwayland qt6.qtwayland
    swww 

    # Waybar para barra de tarefas
    waybar
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GTK_THEME = "Catppuccin-Latte-Pink";
    XCURSOR_THEME = "Catppuccin-Latte-Pink-Cursors";
    XCURSOR_SIZE = "24";
    ROFI_THEME = "catppuccin-latte";
  };

  environment.etc."hypr/hyprland.conf".text = ''
    monitor=,preferred,auto,1

    bind=SUPER,return,exec,alacritty
    bind=SUPER,b,exec,firefox
    bind=SUPER,f,exec,thunar
    bind=SUPER,r,exec,rofi -show drun

    animations {
      enabled=1
      bezier=overshot,0.05,0.9,0.1,1.05
      animation=windows,1,7,overshot
      animation=fade,1,10,default
    }

    general {
      border_size=2
      col.active_border=rgb(ff79c6) rgb(bd93f9) 45deg
      col.inactive_border=rgb(44475a)
    }

    exec-once=hyprpaper &
    wallpaper=,/path/to/your/fabulous-wallpaper.png

    exec-once=rofi -show drun -theme catppuccin-latte &
    exec-once=waybar &
  '';

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  security.polkit.enable = true;

  systemd.user.services.pass = {
    description = "Pass Password Manager";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pass}/bin/pass";
    };
  };

  systemd.user.services.keychain = {
    description = "Keychain SSH Key Manager";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.keychain}/bin/keychain --nogui";
    };
  };

  systemd.user.services.dunst = {
    description = "Dunst Notification Daemon";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };
}
