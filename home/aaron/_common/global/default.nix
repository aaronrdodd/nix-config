{ config, lib, outputs, ... }: {
  imports = [
    ./nix-settings.nix
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "aaron";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };
}

