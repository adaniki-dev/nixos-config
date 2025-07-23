{ config, pkgs, lib, ... }:

{
  imports = [
    # Incluir o resultado do scan de hardware (já existente)
    ./hardware-configuration.nix
    
    # Importações do sistema
    ./system/boot.nix
    ./system/network.nix
    ./system/locale.nix
    ./system/user.nix
    ./system/packages.nix
    ./system/home.nix
    
    # Importações de hardware
    ./hardware/audio.nix
    ./hardware/bluetooth.nix
    ./hardware/graphics.nix
    
    # Importação do desktop (que decidirá qual ambiente usar)
    ./desktop/default.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";



  # Passar a variável desktop para os módulos que precisam dela
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Permitir pacotes unfree
  nixpkgs.config.allowUnfree = true;

  # Habilitar o daemon OpenSSH
  services.openssh.enable = true;

  # Habilitar impressão via CUPS
  services.printing.enable = true;

  # Versão do sistema - NÃO ALTERE após a instalação
  system.stateVersion = "24.11";
}
