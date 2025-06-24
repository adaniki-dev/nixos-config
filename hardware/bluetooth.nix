# hardware/bluetooth.nix
{ config, lib, pkgs, ... }:

{
  # Configuração de Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };

}