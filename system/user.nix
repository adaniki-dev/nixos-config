{ config, lib, pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" "docker" "node" "go" "warp"];
    packages = with pkgs; [
      # Gerenciadores de arquivos
      kdePackages.dolphin
      nautilus
      
      # Editores
      vscode
      kdePackages.kate
      mysql84
      postgresql

      
      # Terminal (versão do PR)
      warp-terminal
      alacritty
      kitty
      gh
      gh-copilot
      neovim
      
      # Aplicações
      spotify
      google-chrome
      firefox
      discord
      slack
      whatsie
      clickup
      postman
      lens
      dbeaver-bin
      bitwarden-desktop
      
      # Screenshot tools
      grimblast
      grim
      slurp

      # Audio/Video controls
      pavucontrol
      
      # System utilities
      htop
      btop
      
      # Network tools
      networkmanagerapplet

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

  # Configuração mínima do home-manager
  home-manager.users.adam = { pkgs, ... }: {
    home.stateVersion = "24.11";
    
    # Configurações básicas
    programs.git = {
      enable = true;
      userName = "adam";
      userEmail = "adam@example.com"; # Substitua pelo seu email
    };

    programs.alacritty = {
      enable = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };
  };

  environment.variables = {
    GOPATH = "$HOME/go";
    GOCACHE = "$HOME/.cache/go-build";
    GOMODCACHE = "$HOME/go/pkg/mod";
  };
}