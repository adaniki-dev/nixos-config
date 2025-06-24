# desktop/gnome.nix
{ config, lib, pkgs, ... }:

{
  # Habilitar o ambiente desktop KDE Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  # Adicionar pacotes específicos do Gnome
  # (A maioria dos pacotes já é instalada pelo Gnome)
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    adwaita-icon-theme
    gnomeExtensions.wallpaper-slideshow  # Para trocar wallpapers automaticamente
    mpvpaper                            # Para vídeos como wallpaper
    # Adicione aqui pacotes específicos do Plasma se necessário
  ];
}