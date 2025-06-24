# desktop/plasma.nix
{ config, lib, pkgs, ... }:

{
  # Habilitar o ambiente desktop KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Adicionar pacotes específicos do Plasma
  # (A maioria dos pacotes já é instalada pelo Plasma)
  environment.systemPackages = with pkgs; [
    # Adicione aqui pacotes específicos do Plasma se necessário
  ];
}