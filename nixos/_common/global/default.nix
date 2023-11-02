{ outputs, pkgs, ... }: {
  imports = [
    ./auto-upgrade.nix
    ./disko.nix
    ./gpg.nix
    ./home-manager.nix
    ./nix-settings.nix
    ./openssh.nix
    ./secrets.nix
    ./security.nix
    ./zram-swap.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
  };
}

