# hardware/graphics.nix
{ config, lib, pkgs, ... }:

{
  # Configuração gráfica para AMD
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}