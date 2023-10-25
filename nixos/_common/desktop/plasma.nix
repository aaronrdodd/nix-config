{ config, pkgs, lib, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

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

    systemPackages = with pkgs; [
      unstable.konsave
      plasma-browser-integration
    ] ++ (if config.services.flatpak.enable
    then [
      libsForQt5.discover
      libsForQt5.packagekit-qt
      packagekit
    ]
    else [ ]);
  };
}

