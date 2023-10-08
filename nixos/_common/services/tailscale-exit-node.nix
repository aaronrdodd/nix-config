{
  imports = [
    ./tailscale
  ];

  services.tailscale = {
    useRoutingFeatures = "both";
  };
}

