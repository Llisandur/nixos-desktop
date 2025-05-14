{ config, pkgs, ... }:

{
  fileSystems."/mnt/media/audiobooks" = {
    device = "nas.lan:/audiobooks";
    fsType = "nfs";
  };
  fileSystems."/mnt/media/books" = {
    device = "nas.lan:/books";
    fsType = "nfs";
  };
  fileSystems."/mnt/docker" = {
    device = "nas.lan:/docker";
    fsType = "nfs";
  };
  fileSystems."/mnt/media/music" = {
    device = "nas.lan:/music";
    fsType = "nfs";
  };
  fileSystems."/mnt/media/videos" = {
    device = "nas.lan:/videos";
    fsType = "nfs4";
  };
  fileSystems."/mnt/roms" = {
    device = "nas.lan:/console_archive";
    fsType = "nfs4";
  };
  fileSystems."/mnt/windows_backup" = {
    device = "nas.lan:/windows_backup";
    fsType = "nfs4";
  };
  fileSystems."/mnt/storage" = {
    device = "nas.lan:/storage";
    fsType = "nfs4";
  };

}
