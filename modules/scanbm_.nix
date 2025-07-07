{ config, pkgs, ... }:

{
  services.saned = {
    enable = true;
    # Add any other sane configuration if needed.
  };

  # Define the socket as a systemd unit.
  systemd.sockets = {
    "saned-stream.socket" = {
      description = "SANE Network Scanner Daemon (stream)";
      wantedBy = [ "multi-user.target" ];
      socketConfig = {
        ListenStream = "0.0.0.0:6567";  # Replace with your desired port
        Accept = true;
      };
    };
  };

  # Define the service that gets triggered by the socket
  systemd.services.saned-stream = {
    description = "SANE Network Scanner Daemon";
    after = [ "network.target" ];

    # The command to run when the socket is triggered
    serviceConfig = {
      ExecStart = "/usr/local/sbin/scanbm scanbm";
      Restart = "always";
      User = "root";  # or the appropriate user for your system
    };

    wantedBy = [ "multi-user.target" ]; # Make sure it is started at the appropriate time
  };

  # Optionally, enable firewall rules for the TCP port
  networking.firewall.allowedTCPPorts = [ 6567 ];  # Replace with your desired port
}
