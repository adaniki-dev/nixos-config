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

    xdg.configFile."hypr/hyprland.conf".source = ./../desktop/hyprland/hyperland.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ./../desktop/hyprland/hyperlock.conf;
    xdg.configFile."kitty/kitty.conf".source = ./../desktop/hyprland/kitty/kitty.conf;
    xdg.configFile."waybar/config".source = ./../desktop/hyprland/waybar/config;
    xdg.configFile."waybar/style.css".source = ./../desktop/hyprland/waybar/style.css;
    xdg.configFile."rofi/config.rasi".source = ./../desktop/hyprland/rofi/config.rasi;
	xdg.configFile."rofi/powermenu.sh".source = ./../desktop/hyprland/rofi/powermenu.sh;
    xdg.configFile."rofi/powermenu.rasi".source = ./../desktop/hyprland/rofi/powermenu.rasi;
  };
}
