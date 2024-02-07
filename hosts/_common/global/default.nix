{ outputs, pkgs, ... }: {
  imports = [
    ./auto-upgrade.nix
    ./disko.nix
    ./firmware-updater.nix
    ./fonts.nix
    ./gpg.nix
    ./home-manager.nix
    ./nix-settings.nix
    ./openssh.nix
    ./secrets.nix
    ./security.nix
    ./substituters.nix
    ./temp-files.nix
    ./zram-swap.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
  };
}

