# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./private.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.useOSProber = true;
    };
    kernelPackages = pkgs.linuxPackages_5_6;
    blacklistedKernelModules = [ "ucsi_acpi" ];
  };

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
  
    wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };

  console = {
    packages = [ pkgs.terminus_font ];
    keyMap = "dvorak";
    font = "ter-132n";
  };
  time.timeZone = "America/New_York";

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };
    systemPackages = with pkgs; [
      nvidia-offload

      alacritty
      dmenu
      firefox
      git
      glxinfo
      hexchat
      kakoune
      ledmon
      lshw
      nix-index
      pciutils
      xmobar
      xorg.xcursorthemes
      xorg.xdpyinfo
      xorg.xkill
      xsel
    ];
  };

  hardware = {
    pulseaudio.enable = true;

    opengl = {
      enable = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
    };

    nvidia.prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services = {
    logind = {
      lidSwitch = "ignore";
    };
    xserver = {
      enable = true;
      dpi = 160;
      layout = "us,us";
      xkbVariant = "dvorak,";
      xkbOptions = "ctrl:swapcaps,grp:ctrl_alt_toggle";
      libinput = {
        enable = true;
        accelSpeed = "0.5";
        naturalScrolling = true;
        disableWhileTyping = true;
      };
      windowManager.xmonad = {
        enable = true;
        extraPackages = hp: [ hp.xmonad-contrib ];
      };
      videoDrivers = [ "nvidia" ];
    };
  };

  users.users.rotaerk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}

