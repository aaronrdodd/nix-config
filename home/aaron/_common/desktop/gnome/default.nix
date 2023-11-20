{ config, lib, ... }:
with lib.hm.gvariant;
let
  avatar = "${../assets/face.png}";
  wallpaper = "file://${config.wallpaper}";
in
{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = wallpaper;
      picture-uri-dark = wallpaper;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaper;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [
        "scale-monitor-framebuffer"
      ];
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];

      favorite-apps = [
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "vivaldi-stable.desktop"
        "vlc.desktop"
        "org.gnome.Software.desktop"
      ];
    };

    "com/raggesilver/BlackBox" = {
      opacity = mkUint32 100;
    };
  };

  home.file.".face".source = avatar;
}

