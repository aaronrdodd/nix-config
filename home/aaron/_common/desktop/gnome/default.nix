{ lib, ... }:
with lib.hm.gvariant;
let
  avatar = "${../assets/face.png}";
in
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
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
        "dash-to-dock@micxgx.gmail.com"
        "kimpanel@kde.org"
      ];

      favorite-apps = [
        "com.raggesilver.BlackBox.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "chromium-browser.desktop"
        "vlc.desktop"
        "org.gnome.Software.desktop"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = true;
    };

    "com/raggesilver/BlackBox" = {
      opacity = mkUint32 100;
    };
  };

  home.file.".face".source = avatar;
}

