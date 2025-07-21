{ config, pkgs, ... }:

{
  home-manager.users.adam = {
    home.stateVersion = "24.11";

    programs.git = {
      enable = true;
      userName = "adaniki-dev";
      userEmail = "ikiyoshikai@gmail.com";
    };

    programs.kitty.enable = true;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    xdg.configFile."hypr/hyprland.conf".source = /etc/nixos/desktop/hyprland/hyperland.conf;
    xdg.configFile."hypr/hyprlock.conf".source = /etc/nixos/desktop/hyprland/hyperlock.conf;
    xdg.configFile."kitty/kitty.conf".source = /etc/nixos/desktop/hyprland/kitty/kitty.conf;
    xdg.configFile."waybar/config".source = /etc/nixos/desktop/hyprland/waybar/config;
    xdg.configFile."waybar/style.css".source = /etc/nixos/desktop/hyprland/waybar/style.css;
    xdg.configFile."rofi/config.rasi".source = /etc/nixos/desktop/hyprland/rofi/config.rasi;
  };
}
