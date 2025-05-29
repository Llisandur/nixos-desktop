{ pkgs, lib, ... }:

let

  eorzean-typeface = import (fetchTarball https://github.com/Llisandur/Eorzean-Typeface-Nix/archive/refs/tags/v1.05.tar.gz) {inherit pkgs lib; };
  eorzean-typeface-nerdfont = import (fetchTarball https://github.com/Llisandur/Eorzean-Typeface-Nerdfont-Nix/archive/refs/tags/v1.03.tar.gz) { inherit pkgs lib; };

in

{

  # Font configuration
  fonts = {
    packages = with pkgs; [
#      (nerdfonts.override { fonts = [
#      "FiraCode"
#      "Inconsolata"
#      "JetBrainsMono"
#      ];})
#      corefonts
      font-awesome
      material-icons
      migu  # Japanese font fix within programs
      nerdfonts
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