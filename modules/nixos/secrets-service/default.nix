{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.nixos.secrets-service;
  gnomeEnabled = config.services.xserver.desktopManager.gnome.enable;
  plasmaEnabled = config.services.xserver.desktopManager.plasma5.enable;
in
{
  options.nixos.secrets-service = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the secrets-service configuration.";
      default = false;
    };
    defaultSecretsService = mkOption {
      type = types.enum [
        "default"
        "keepassxc"
      ];
      description = "The secrets service implementation to use.";
      default = "default";
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # KeePassXC + Gnome
    (mkIf (cfg.defaultSecretsService == "keepassxc" && gnomeEnabled) {
      services.gnome.gnome-keyring.enable = mkForce false;
      programs.seahorse.enable = mkForce false;

      programs.ssh = {
        enableAskPassword = mkForce true;
        askPassword = mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
      };

      environment.systemPackages = with pkgs; [
        keepassxc
      ];
    })

    # KeePassXC + Plasma
    (mkIf (cfg.defaultSecretsService == "keepassxc" && plasmaEnabled) {
      programs.ssh = {
        enableAskPassword = mkForce true;
        askPassword = mkForce "${pkgs.libsForQt5.ksshaskpass.out}/bin/ksshaskpass";
      };
    })
  ]);
}
