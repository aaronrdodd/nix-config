{ pkgs, config, ... }:
let
  inherit (config.networking) hostName;

  userName = "aaron";
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
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

    initialPassword = "hunter2";
    packages = with pkgs; [
      chezmoi
      git
      home-manager
      vim
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrcF+PGbXSa+KkZgSupx405LXQE+oSQY6tp30p735Nj aaron@vmware"
    ];
  };

  home-manager.users.${userName} = import ../../../../home/${userName}/${hostName}.nix;

  programs.fish.enable = true;
}

