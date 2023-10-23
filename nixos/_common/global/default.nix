{ outputs, pkgs, ... }: {
  imports = [
    ./auto-upgrade.nix
    ./disko.nix
    ./gpg.nix
    ./home-manager.nix
    ./nix-settings.nix
    ./openssh.nix
    ./security.nix
    ./systemd-initrd.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
  };
}

