{ config, lib, pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" "docker" "node" "go" "warp"];
    packages = with pkgs; [
      # Gerenciadores de arquivos
      kdePackages.dolphin
      
      # Editores
      vscode
      kdePackages.kate
      mysql84
      postgresql

      
      # Terminal (versão do PR)
      warp-terminal
      gh
      gh-copilot
      neovim
      
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
      grimblast

      #runners
      nodejs_22
      typescript
      go
      gcc
      gopls
      goimports-reviser
      gnumake
      sqlite
      pkg-config
    ];
  };

  environment.variables = {
    GOPATH = "$HOME/go";
    GOCACHE = "$HOME/.cache/go-build";
    GOMODCACHE = "$HOME/go/pkg/mod";
  };

}