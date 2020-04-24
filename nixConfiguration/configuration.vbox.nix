{ config, pkgs, ... }:

{
  imports =
    [
      ./configuration.nix
    ];

  virtualisation.virtualbox.guest.enable = true;
}
