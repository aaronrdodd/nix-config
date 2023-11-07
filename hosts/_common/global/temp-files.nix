{ config, lib, ... }:
with lib;
let
  mkTempDirectory = name: user: "d ${user.home}/Temp 0700 ${name} ${user.group} 7d";
in
{
  systemd.tmpfiles.rules = mapAttrsToList mkTempDirectory (filterAttrs (_: user: user.isNormalUser) config.users.users);
}

