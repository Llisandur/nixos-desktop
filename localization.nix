{ pkgs, ... }:

{

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    # Input method configuration
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
        plasma6Support = true;
        waylandFrontend = true;
      };
    };
  };


  environment.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
#    QT_IM_MODULE = "fcitx";
#    GTK_IM_MODULE = "fcitx";
  };

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
    ];
    # Enable the system-wide directory for fonts
#    fontDir.enable = true;
#    fontconfig.enable = true;
    # Custom font configuration
    # This block configures the font settings specifically for the Steam application. 
    # It sets the 'Migu 1P' font for Steam, particularly for the 'steamwebhelper' process, ensuring that Steam displays text using this font instead of the default sans-serif font.
#    fontconfig = {
#      localConf = ''
#        <?xml version="1.0"?>
#        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
#        <fontconfig>
#          <description>Change default fonts for Steam client</description>
#          <match>
#            <test name="prgname">
#              <string>steamwebhelper</string>
#            </test>
#            <test name="family" qual="any">
#              <string>sans-serif</string>
#            </test>
#            <edit mode="prepend" name="family">
#              <string>Migu 1P</string>
#            </edit>
#          </match>
#        </fontconfig>
#      '';
#      };
  };
  #i18n.fonts.fontDir.enable = true;
#  systemd.user.services.link-fonts = {
#    description = "Create symbolic link for fonts";
#    wantedBy = [ "default.target" "graphical-session.target" ];
#    before = [ "graphical-session.target" ];
#    serviceConfig = {
#      Type = "oneshot";
#      RemainAfterExit = true;
#      ExecStartPre = ''
#        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.local/share && ${pkgs.coreutils}/bin/mkdir -p %h/.local/share || ${pkgs.coreutils}/bin/true"
#      '';
#      ExecStart = ''
#        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.local/share/fonts && ${pkgs.coreutils}/bin/ln -s /run/current-system/sw/share/X11/fonts %h/.local/share/fonts || ${pkgs.coreutils}/bin/true"
#      '';
#    };
#  };
}