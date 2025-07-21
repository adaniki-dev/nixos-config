{
  description = "Minha configuração NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";
    claude-desktop.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, claude-desktop, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ({ config, pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = [
            # Ou use claude-desktop-with-fhs se preferir:
            claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
          ];
        })
      ];
    };
  };
}