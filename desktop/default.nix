{ config, lib, pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    #./gnome.nix
   # ./plasma.nix
  ];

  services.xserver.enable = true;
} 