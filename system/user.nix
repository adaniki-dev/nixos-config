{ config, lib, pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" "docker" "node"];
    packages = with pkgs; [
      # Gerenciadores de arquivos
      kdePackages.dolphin
      
      # Editores
      vscode
      kdePackages.kate
      
      # Terminal (versão do PR)
      warp-terminal
      
      # Aplicações
      spotify
      google-chrome
      discord
      slack
      whatsie
      clickup
      postman
      lens
      dbeaver-bin
      bitwarden-desktop
    ];
  };

}