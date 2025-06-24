# system/packages.nix
{ config, lib, pkgs, desktopEnvironment, ... }:

{
  # Pacotes comuns para todos os ambientes
  environment.systemPackages = with pkgs; [
    # Ferramentas essenciais
    kubectl
    k3s
    kubernetes-helm
    kustomize

    k9s

    wget
    curl
    git
    kubectl
    azure-cli
    go
    docker
    heroic
    winetricks
    protontricks
  ];

  # Configuração de fontes
  fonts.packages = with pkgs; [
    font-awesome
  ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [
      "--write-kubeconfig-mode=644"
      "--disable=traefik"
      "--disable=servicelb"
    ];
  };

networking.firewall.allowedTCPPorts = [ 6443 ];
networking.firewall.allowedUDPPorts = [ 8472 ];

  virtualisation.docker = {
    enable = true;
  };

}