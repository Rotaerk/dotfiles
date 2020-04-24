{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
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
    kernelPackages = pkgs.linuxPackages_5_6;
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
  
    wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };

  environment.systemPackages = [ nvidia-offload ];

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services = {
    logind = {
      lidSwitch = "ignore";
    };
    xserver = {
      dpi = 160;
      libinput = {
        enable = true;
        accelSpeed = "0.5";
        naturalScrolling = true;
        disableWhileTyping = true;
      };
      videoDrivers = [ "nvidia" ];
    };
  };
}

