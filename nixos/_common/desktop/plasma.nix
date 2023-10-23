{ config, pkgs, lib, ... }: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.packagekit.enable = true;

  programs = {
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    ssh.askPassword = lib.mkForce "${pkgs.libsForQt5.ksshaskpass.out}/bin/ksshaskpass";
  };

  environment = {
    etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

    systemPackages = with pkgs;
      if config.services.flatpak.enable
      then [
        libsForQt5.discover
        libsForQt5.packagekit-qt
        packagekit
      ]
      else [ ] ++ [ plasma-browser-integration ];
  };
}

