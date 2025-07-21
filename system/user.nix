{ config, lib, pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    description = "adam";
    extraGroups = [ "networkmanager" "wheel" "docker" "node" "go" "warp" ];
    packages = with pkgs; [
      nautilus
      vscode
      kdePackages.kate
      mysql84 postgresql
      warp-terminal alacritty kitty gh gh-copilot neovim
      spotify google-chrome firefox discord slack whatsie clickup postman lens dbeaver-bin bitwarden-desktop
      grimblast grim slurp
      pavucontrol
      htop btop
      networkmanagerapplet

      # Dev env
      nodejs_22 typescript go gcc gopls goimports-reviser gnumake sqlite pkg-config
    ];
  };

  environment.variables = {
    GOPATH = "$HOME/go";
    GOCACHE = "$HOME/.cache/go-build";
    GOMODCACHE = "$HOME/go/pkg/mod";
  };
}
