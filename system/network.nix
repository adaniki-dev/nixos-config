# system/network.nix
{ config, lib, pkgs, ... }:

{
  # Definir hostname
  networking.hostName = "nixos";
  
  # Habilitar NetworkManager
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 9090 ];
}