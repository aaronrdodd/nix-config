{ config, pkgs, ... }: {
  nixos.oci-containers = {
    enable = true;
    backend = "podman";
  };

  environment.systemPackages = with pkgs;
    if config.nixos.oci-containers.backend == "docker"
    then [ docker docker-compose ]
    else [ podman podman-compose ];

  networking.firewall.trustedInterfaces =
    if config.nixos.oci-containers.backend == "docker"
    then [ "docker0" ]
    else [ "podman" ];
}

