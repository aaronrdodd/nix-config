{ config, pkgs, ... }:
let
  inherit (config.networking) hostName;

  userName = "aaron";
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  sops.secrets."users/aaron/password" = {
    neededForUsers = true;
  };

  users.users.${userName} = {
    description = "Aaron Dodd";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "video"
      "wheel"
    ] ++ ifGroupsExist [
      "docker"
      "git"
      "network"
      "podman"
    ];

    initialPassword = config.sops.secrets."users/aaron/password".path;
    packages = with pkgs; [
      bitwarden
      bitwarden-cli
      chezmoi
      git
      home-manager
      keepassxc
      sops
      tor-browser-bundle-bin
      vim
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrcF+PGbXSa+KkZgSupx405LXQE+oSQY6tp30p735Nj aaron@vmware"
    ];
  };

  home-manager.users.${userName} = import ../../../../home/${userName}/${hostName}.nix;

  programs.fish.enable = true;
}

