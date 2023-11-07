{ config, inputs, pkgs, lib, ... }:
let
  isClean = inputs.self ? rev;
in
{
  system.autoUpgrade = {
    enable = isClean;
    dates = "hourly";
    flags = [
      "--refresh"
    ];
    flake = "github:aaron-dodd/nix-config";
    allowReboot = true;
    rebootWindow = {
      lower = "17:45";
      upper = "23:45";
    };
  };

  # Only run if current config (self) is older than the new one.
  systemd.services.nixos-upgrade = lib.mkIf config.system.autoUpgrade.enable {
    serviceConfig.ExecCondition = lib.getExe (
      pkgs.writeShellScriptBin "check-date" ''
        lastModified() {
          nix flake metadata "$1" --refresh --json | ${lib.getExe pkgs.jq} '.lastModified'
        }
        test "$(lastModified "${config.system.autoUpgrade.flake}")"  -gt "$(lastModified "self")"
      ''
    );
  };
}

