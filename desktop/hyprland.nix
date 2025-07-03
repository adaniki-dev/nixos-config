{ config, lib, pkgs, ... }:

{
  # Adiciona pacotes essenciais ao sistema
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

  # Ativa o Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # Ativa o XWayland para compatibilidade com apps X11
  };

  # Variáveis de sessão para Wayland e ambiente específico
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";  # Desativa o cursor de hardware
    NIXOS_OZONE_WL = "1";           # Usar Ozone para Wayland
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    
    # Configurações do Qt para Wayland
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    # Tamanho do cursor
    XCURSOR_SIZE = "24";
  };

  # Arquivo de configuração do Hyprland
  environment.etc."hypr/hyprland.conf".text = ''
    # Configuração do monitor
    monitor=,preferred,auto,1

    # Atalhos de teclado
    bind=SUPER,return,exec,alacritty
    bind=SUPER,b,exec,firefox
    bind=SUPER,f,exec,thunar
    bind=SUPER,r,exec,rofi -show drun

    # Controles de áudio
    bind=SUPER,equal,exec,pamixer -i 5
    bind=SUPER,minus,exec,pamixer -d 5
    bind=SUPER,0,exec,pamixer -t

    # Controles de brilho
    bind=,XF86MonBrightnessUp,exec,brightnessctl set +5%
    bind=,XF86MonBrightnessDown,exec,brightnessctl set 5%-

    # Teclas de mídia
    bind=,XF86AudioRaiseVolume,exec,pamixer -i 5
    bind=,XF86AudioLowerVolume,exec,pamixer -d 5
    bind=,XF86AudioMute,exec,pamixer -t
    bind=,XF86AudioPlay,exec,playerctl play-pause
    bind=,XF86AudioNext,exec,playerctl next
    bind=,XF86AudioPrev,exec,playerctl previous

    # Animações de janela
    animations {
      enabled=1
      bezier=overshot,0.05,0.9,0.1,1.05
      animation=windows,1,7,overshot
      animation=fade,1,10,default
    }

    # Configurações gerais
    general {
      border_size=2
      col.active_border=rgb(ff79c6) rgb(bd93f9) 45deg
      col.inactive_border=rgb(44475a)
    }

    # Execuções automáticas
    exec-once=hyprpaper &
    wallpaper=,/path/to/your/fabulous-wallpaper.png

    exec-once=rofi -show drun &
    exec-once=waybar &
  '';

  # Configuração do Waybar
  environment.etc."xdg/waybar/config".source = ./hyprland/waybar/config;

  # Configuração do estilo do Waybar
  environment.etc."xdg/waybar/style.css".source = ./hyprland/waybar/style.css;

  # Habilita o polkit para permissões no sistema
  security.polkit.enable = true;

  # Serviço do Password Manager
  systemd.user.services.pass = {
    description = "Pass Password Manager";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pass}/bin/pass";
    };
  };

  # Serviço do Keychain
  systemd.user.services.keychain = {
    description = "Keychain SSH Key Manager";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.keychain}/bin/keychain --nogui";
    };
  };

  # Serviço do Dunst
  systemd.user.services.dunst = {
    description = "Dunst Notification Daemon";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };
}
