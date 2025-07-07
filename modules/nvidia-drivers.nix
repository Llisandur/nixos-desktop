{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.nvidia;
in
{
  options.drivers.nvidia = {
    enable = mkEnableOption "Enable Nvidia Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;  # Modesetting is required.
      powerManagement.enable = false;  # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.finegrained = false;  # Fine-grained power management. Turns off GPU when not in use. Experimental and only works on modern Nvidia GPUs (Turing or newer).
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      nvidiaSettings = true;  # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      # Optionally, you may need to select the appropriate driver version for your specific GPU.
#      package = config.boot.kernelPackages.nvidiaPackages.beta;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#        version = "570.144";
#        sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
#        sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
#        openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
#        settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
#        persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
        version = "575.57.08";
        sha256_64bit = "sha256-KqcB2sGAp7IKbleMzNkB3tjUTlfWBYDwj50o3R//xvI=";
        sha256_aarch64 = "sha256-VJ5z5PdAL2YnXuZltuOirl179XKWt0O4JNcT8gUgO98=";
        openSha256 = "sha256-DOJw73sjhQoy+5R0GHGnUddE6xaXb/z/Ihq3BKBf+lg=";
        settingsSha256 = "sha256-AIeeDXFEo9VEKCgXnY3QvrW5iWZeIVg4LBCeRtMs5Io=";
        persistencedSha256 = "sha256-Len7Va4HYp5r3wMpAhL4VsPu5S0JOshPFywbO7vYnGo=";
      };
    };
  };
}
