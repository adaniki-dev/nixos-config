{
  description = "Minha configuração NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    hyprland.url = "github:hyprwm/Hyprland"; # <- adicionando o flake do Hyprland
  };

  outputs = { self, nixpkgs, flake-utils, claude-desktop, home-manager, hyprland, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager

        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;

          environment.systemPackages = [
            claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
          ];

          # Ativa Hyprland com suporte ao hyprcursor
          programs.hyprland = {
            enable = true;
            xwayland.enable = true;
            package = hyprland.packages.${pkgs.system}.hyprland;
          };
        })
      ];
    };
  };
}

