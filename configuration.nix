# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, options, ... }:

# Import Nixos unstable packages.
let
  unstableTarball = fetchTarball
    https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  unstable = import unstableTarball { config = { allowUnfree = true; }; overlays = []; };

  inherit (import ./variables.nix) host gitUsername gitEmail;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./modules/local-hardware-clock.nix
      ./modules/intel-drivers.nix
      ./modules/nvidia-drivers.nix
      ./remote-drives.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest; # for WiFi support
    # Bootloader
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Graphical boot splash
    plymouth.enable = true;
  };

  # Extra module options
  drivers = {
    # amdpgu.enable = false;
    nvidia.enable = false;
#    nvidia-prime = {
#      enable = false;
#      intelBusID = "";
#      nvidiaBusID = "";
#    };
    intel.enable = true;
  };
#  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Enable networking
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      # enable = false; # Disable the firewall
#      allowedTCPPorts = [ 80 8080 443 ]; # Open ports in the firewall.
      allowedTCPPortRanges = [
        { from=54992; to=54994; }  # Ports for FF14
        { from=55006; to=55007; }  # Ports for FF14
        { from=55021; to=55040; }  # Ports for FF14
      ]; # Open ports in the firewall.
#      allowedUDPPorts = [ ... ];
#      allowedUDPPortRanges = [{ from=55296; to=55551; }];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
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
  };

  fileSystems = {
    # Mount disk drives.
    "/run/media/llisandur/games" = {
      device = "/dev/disk/by-label/games";
      fsType = "ext4";
    };
  };

  programs = {
    # kde packages
    kdeconnect = {
      enable = true;
      #package = pkgs.kdePackages.kdeconnect-kde;
    };
    kde-pim = {
      enable = true; # kmail, kontact, merkuro (calendar)
      kmail = true;
      kontact = true;
      merkuro = true;
    };
    # browser
#    firefox.enable = true;
    # games
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
    };
    gamemode.enable = true;
    # system Programs
    appimage = {
      enable = true;
      binfmt = true;
    };
    streamdeck-ui = {
      enable = true;
      autoStart = true;
    };
    # terminal
    zsh = {
      enable = true;
      autosuggestions = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      ohMyZsh = {
        enable = true;
        #theme = "juanghurtado";
        #theme = "powerlevel10k/powerlevel10k";
        plugins = [ "git" ];
      };
    };
    # version control
    git = {
      enable = true;
      config = {
        init.defaultBranch = "master";
        user.name = "${gitUsername}";
        user.email = "${gitEmail}";
      };
      lfs.enable = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;  # Allow unfree packages
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      btop
      tree
      wget
#      dislocker
      libguestfs
      samba
      gparted
      # kde packages
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.krdc
      kdePackages.krfb
      kdePackages.kdeconnect-kde
      kdePackages.plasma-browser-integration
      # audio
      pavucontrol
      # browser
#      firefox
      microsoft-edge
      # cloud services
      nextcloud-client
      # coding
      unstable.vscode
      # communication
      discord
      telegram-desktop
      # compatibility
      bottles
      # games
      protontricks
      protonup-qt
      steam
      xivlauncher
      #unstable.archipelago
      # hardware stats
      dmidecode
      lshw
      # internet
      mullvad-vpn
#      openvpn3
      # media
      unstable.gimp3
      jellyfin-media-player
      vlc
      # nix control
      nh
      nix-output-monitor
      nvd
      # office
#      joplin-desktop
      libreoffice-fresh
      obsidian
#      thunderbird
      # shell emulator
      kitty
      kitty-img
      pixcat
      # terminal
      zsh
      zsh-powerlevel10k
      # Utility
      libsForQt5.filelight
      # version control
      gh
      git
    ];
  };

  fonts = {
    packages = with pkgs; [
      # corefonts
      font-awesome
      material-icons
      nerdfonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      symbola
      # vistafonts
    ];
  };

  # Extra portal configuration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "gtk";
  };

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    desktopManager = {
      plasma6 = {
        enable = true;  # Enable the KDE Plasma Desktop Environment.
      };
    };
    flatpak.enable = true;  # Enable flatpak containers
    fprintd.enable = true;  # Enable fingerprint reader support
    # Enable VPN
    mullvad-vpn.enable = true;
    openssh.enable = true;  # Enable the OpenSSH daemon.
    pipewire = {
      enable = true;  # Enable sound.
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    printing.enable = true;  # Enable CUPS to print documents.
    avahi = {
      enable=true;  # Enable printing services (Brother printer)
      nssmdns4=true;
      openFirewall=true;
    };
    xserver = {
      enable = true;  # Enable the X11 windowing system.
      xkb = {  # Configure keymap in X11
        layout = "us";
        variant = "";
      };
    };
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo'';
  };


  # Hardware settings
  hardware = {
    pulseaudio = {
      enable = false; # Disable Pulseaudio -- using Pipewire
      extraConfig = "load-module module-combine-sink";
    };
    # Enable Bluetooth
    bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
    # Scanner access easy now
    sane = {
      enable = true;
      extraBackends = [];
      disabledDefaultBackends = [];
      drivers = {
        scanSnap = {
          enable = true;
        };
      };
    };
    xone.enable = true;  # Set up Microsoft accessories drivers.
    graphics.enable = true;
  };

  # Security
  security = {
    rtkit.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
