{ config, lib, ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  networking.firewall = {
    checkReversePath = "loose";

    # Facilitate firewall punching
    allowedUDPPorts = [
      config.services.tailscale.port
    ];
  };
}

