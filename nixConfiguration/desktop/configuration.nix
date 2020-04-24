{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./private.nix
      ./common.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sdc";
    extraEntries = ''
      menuentry "Windows 10" {
        insmod ntfs
        search --no-floppy --set=root --fs-uuid 9C4230E94230CA32
        ntldr /bootmgr
      }
    '';
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
