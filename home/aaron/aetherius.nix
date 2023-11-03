{ outputs, ... }: {
  imports = [
    ./_common/cli
    ./_common/desktop/applications
    ./_common/desktop/gnome
    ./_common/emacs
    ./_common/global
    ./_common/neovim
    ./_common/services/syncthing.nix
  ];

  wallpaper = outputs.wallpapers.ocean-sunset;
}
