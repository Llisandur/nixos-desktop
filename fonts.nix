{ pkgs, lib, ... }:

let

  eorzean-typeface = import <eorzean-typeface> { inherit pkgs lib; };
  eorzean-typeface-nerdfont = import <eorzean-typeface-nerdfont> { inherit pkgs lib; };

in

{

  # Font configuration
  fonts = {
    packages = with pkgs; [
      corefonts
      font-awesome
      material-icons
      migu  # Japanese font fix within programs
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.fira-code
      nerd-fonts.inconsolata
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      symbola
#      vistafonts
      eorzean-typeface
      eorzean-typeface-nerdfont
    ];
    # Enable the system-wide directory for fonts
#    fontDir.enable = true;
#    fontconfig.enable = true;
  };
}
