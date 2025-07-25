# system/locale.nix
{ config, lib, pkgs, ... }:

{
  # Configurar fuso horário
  time.timeZone = "America/Sao_Paulo";

  # Configurações de internacionalização
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
    LC_CTYPE = "pt_BR.UTF-8";
  };

  # Configuração do fcitx5 para input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-configtool
      fcitx5-gtk
      fcitx5-qt
      fcitx5-with-addons
    ];
  };

  # Layout de teclado para X11 (para compatibilidade)
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
    options = "compose:ralt";
  };

  # Variáveis de ambiente para input method
  environment.sessionVariables = {
    # Locale
    LC_ALL = "pt_BR.UTF-8";
    LC_CTYPE = "pt_BR.UTF-8";
    LANG = "pt_BR.UTF-8";
    
    # Input Method
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
    IMSETTINGS_MODULE = "fcitx";
    
    # XKB para Wayland
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_VARIANT = "intl";
    XKB_DEFAULT_OPTIONS = "compose:ralt";
  };
}
