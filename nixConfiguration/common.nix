{ config, pkgs, ... }:

{
  users.users.rotaerk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  time.timeZone = "America/New_York";

  console = {
    packages = [ pkgs.terminus_font ];
    keyMap = "dvorak";
    font = "ter-132n";
  };
  
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      EDITOR = "kak";
      VISUAL = "kak";
    };

    systemPackages = with pkgs; [
      alacritty
      dmenu
      firefox
      gitFull
      glxinfo
      hexchat
      kakoune
      ledmon
      linuxPackages.virtualboxGuestAdditions
      lshw
      nix-index
      pciutils
      shutter
      unzip
      vlc
      xmobar
      xorg.xdpyinfo
      xorg.xkill
      xsel
    ];
  };

  services = {
    xserver = {
      enable = true;
      layout = "us,us";
      xkbVariant = "dvorak,";
      xkbOptions = if config.virtualisation.virtualbox.guest.enable then "grp:alt_caps_toggle" else "ctrl:swapcaps,grp:ctrl_alt_toggle";
      windowManager.xmonad = {
        enable = true;
        extraPackages = hp: [ hp.xmonad-contrib ];
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?
}
