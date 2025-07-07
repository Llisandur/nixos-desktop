{ config, pkgs, ... }:

{
  services.saned.enable = true;
  systemd.sockets.sane-port = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "6566" ];
  };

  systemd.services.sane-port = {
    description = "Scanbm Socket Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ]; # Optional
    serviceConfig = {
      ExecStart = "${pkgs.scanbd}/sbin/scanbm scanbm";
      User = "root";
      Group = "scanner";
      StandardInput = "socket";
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
