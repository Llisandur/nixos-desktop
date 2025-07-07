{ config, lib, pkgs, ... }:

with lib;

let
  configDir = "/etc/scanbd";
  saneConfigDir = "${configDir}/sane.d";

  scanbdConf = pkgs.writeText "scanbd.conf"
    ''
      global {
        debug = true
        debug-level = ${toString config.services.scanbd.debugLevel}
        user = ${config.services.scanbd.user}
        group = ${config.services.scanbd.group}
        scriptdir = ${configDir}/scripts
        pidfile = ${config.services.scanbd.pidFile}
        timeout = ${toString config.services.scanbd.timeOut}
        environment {
          device = "SCANBD_DEVICE"
          action = "SCANBD_ACTION"
        }

        multiple_actions = true
        action scan {
          filter = "^scan.*"
          numerical-trigger {
            from-value = 1
            to-value = 0
          }
          desc = "Scan to file"
          script = "scan.script"
        }
        ${config.services.scanbd.extraConfig}
      }
    '';

  scanScript = pkgs.writeScript "scanbd_scan.script"
    ''
      #! ${pkgs.bash}/bin/bash
      export PATH=${lib.makeBinPath [ pkgs.coreutils pkgs.sane-frontends pkgs.sane-backends pkgs.ghostscript pkgs.imagemagick ]}
      set -x
      date="$(date --iso-8601=seconds)"
      filename="scan_$date.pdf"
      tmpdir="$(mktemp -d)"
      pushd "$tmpdir"
      scanadf -d "$SCANBD_DEVICE" --source "${config.services.scanbd.scansource}" --mode ${config.services.scanbd.scanmode} --resolution ${builtins.toString config.services.scanbd.scanresolution}dpi

      # Convert any PNM images produced by the scan into a PDF with the date as a name
      convert image* -density ${builtins.toString config.services.scanbd.scanresolution} "$filename"
      chmod 0666 "$filename"

      # Remove temporary PNM images
      rm image*

      # Atomic move converted PDF to destination directory
      outfile="${config.services.scanbd.scantodir}"
      mv $filename $outfile

      popd
      rm -r "$tmpdir"
    '';

in

{

  ###### interface
  options = {

    services.scanbd.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable support for scanbd (scanner button daemon).

        <note><para>
          If scanbd is enabled, then saned must be disabled.
        </para></note>
      '';
    };

    services.scanbd.user = mkOption {
      type = types.str;
      default = "scanner";
      example = "";
      description = ''
        scanbd daemon user name.
      '';
    };

    services.scanbd.group = mkOption {
      type = types.str;
      default = "scanner";
      example = "";
      description = ''
        scanbd daemon group name.
      '';
    };

    services.scanbd.extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        device canon {
          filter = "^genesys.*"
          desc = "Canon LIDE"
          action file {
            filter = "^file.*"
            desc = "File"
            script = "copy.script"
          }
        }
        '';
      description = ''
        Extra configuration lines included verbatim in scanbd.conf.
        Use e.g. in lieu of including device-specific config templates
        under scanner.d/
      '';
    };

    services.scanbd.pidFile = mkOption {
      type = types.str;
      default = "/var/run/scanbd.pid";
      example = "";
      description = ''
        PID file path.
      '';
    };

    services.scanbd.timeOut = mkOption {
      type = types.int;
      default = 500;
      example = "";
      description = ''
        Device polling timeout (in ms).
      '';
    };

    services.scanbd.debugLevel = mkOption {
      type = types.int;
      default = 3;
      example = "";
      description = ''
        Debug logging (1=error, 2=warn, 3=info, 4-7=debug)
      '';
    };

    services.scanbd.scansource = mkOption {
      type = types.str;
      default = "ADF Duplex";
      example = "";
      description = ''
        Scanning source type. Options are ADF Front, ADF Back, ADF Duplex.
      '';
    };

    services.scanbd.scanmode = mkOption {
      type = types.str;
      default = "Gray";
      example = "Gray";
      description = ''
        Scanning mode. Options are Lineart, Gray, Color.
      '';
    };

    services.scanbd.scanresolution = mkOption {
      type = types.int;
      default = 200;
      example = "200";
      description = ''
        Resolution for the scan.
      '';
    };

    services.scanbd.scantodir = mkOption {
      type = types.str;
      default = "/var/lib/paperless/consume";
      example = "";
      description = ''
        Directory to send the scans.
      '';
    };

  };

  ###### implementation
  config = mkIf config.services.scanbd.enable {

      users.groups.scanner.gid = config.ids.gids.scanner;
      users.users.scanner = {
        uid = config.ids.uids.scanner;
        group = "scanner";
      };

      environment.etc."scanbd/scanbd.conf".source = scanbdConf;
      environment.etc."scanbd/scripts/scan.script".source = scanScript;
      environment.etc."scanbd/scripts/test.script".source = "${pkgs.scanbd}/etc/scanbd/test.script";

      systemd.services.scanbd = {
        enable = true;
        description = "Scanner button polling service";
        documentation = [ "https://sourceforge.net/p/scanbd/code/HEAD/tree/releases/1.5.1/integration/systemd/README.systemd" ];
        script = "${pkgs.scanbd}/bin/scanbd -c ${configDir}/scanbd.conf -f";
        wantedBy = [ "multi-user.target" ];
        aliases = [ "dbus-de.kmux.scanbd.server.service" ];
      };
  };
}