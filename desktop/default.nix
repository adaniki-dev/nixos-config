{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    #./gnome.nix
    #./plasma.nix
  ];

  # X11 não é necessário para Hyprland puro, mas mantenha se usar aplicações X11
  services.xserver.enable = true;
}