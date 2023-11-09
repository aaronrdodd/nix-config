{ config, ... }:
let
  gnomeEnabled = config.services.xserver.desktopManager.gnome.enable;
  plasmaEnabled = config.services.xserver.desktopManager.plasma5.enable;
in
{
  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
      publish = {
        enable = true;

        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = gnomeEnabled || plasmaEnabled;
      };
    };
  };
}

