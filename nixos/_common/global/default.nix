{ outputs, pkgs, ... }: {
  imports = [
    ./auto-upgrade.nix
    ./disko.nix
    ./home-manager.nix
    ./nix-settings.nix
    ./openssh.nix
    ./security.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
  };
}

