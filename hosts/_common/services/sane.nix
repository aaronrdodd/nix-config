{ config, pkgs, lib, ... }:
let
  gnomeEnabled = config.services.xserver.desktopManager.gnome.enable;
  plasmaEnabled = config.services.xserver.desktopManager.plasma5.enable;
in
{
  environment.systemPackages = with pkgs; lib.optionals (gnomeEnabled || plasmaEnabled) [
    gnome.simple-scan
  ];

  hardware = {
    sane = {
      enable = true;
      extraBackends = with pkgs; [ sane-airscan ];
    };
  };
}

