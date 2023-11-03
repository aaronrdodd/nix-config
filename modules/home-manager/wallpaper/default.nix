{ lib, ... }:
with lib;
{
  options.wallpaper = mkOption {
    type = types.path;
    default = "";
    description = "The path to the wallpaper";
  };
}

