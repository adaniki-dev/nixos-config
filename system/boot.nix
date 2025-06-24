# system/boot.nix
{ config, lib, pkgs, ... }:

{
  # Configuração do bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}