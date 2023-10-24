{ config, inputs, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../${hostName}/secrets.yaml;
}

