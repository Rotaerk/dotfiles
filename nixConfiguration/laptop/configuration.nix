{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./private.nix
      ./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.useOSProber = true;
    };
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
  
    wireless = {
      enable = true; # Enables wireless support via wpa_supplicant.
      userControlled.enable = true;
      interfaces = [ "wlo1" ];
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services = {
    logind = {
      lidSwitch = "ignore";
    };
    xserver = {
      dpi = 160;
      libinput = {
        enable = true;
        touchpad = {
          accelSpeed = "0.5";
          naturalScrolling = true;
          disableWhileTyping = true;
        };
      };
      videoDrivers = [ "nvidia" ];
    };
  };
}

