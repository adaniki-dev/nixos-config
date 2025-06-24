# hardware/audio.nix
{ config, lib, pkgs, ... }:

{
  # Configuração do Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Desabilitar PulseAudio para usar Pipewire
  services.pulseaudio.enable = false;

  # Habilitar rtkit para audio
  security.rtkit.enable = true;
}