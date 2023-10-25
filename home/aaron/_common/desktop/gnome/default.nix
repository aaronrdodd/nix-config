{ lib, ... }:
with lib.hm.gvariant;
let
  avatar = "${../assets/face.png}";
  wallpaper = "file://${../assets/bliss.jpg}";
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

    "org/gnome/desktop/screensaver" = {
      picture-uri = wallpaper;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
      ];
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "chromium-browser.desktop"
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

