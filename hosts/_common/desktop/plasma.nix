{ config, pkgs, lib, ... }: {
  # Enable the KDE Plasma Desktop Environment.
  services.xserver = {
    enable = true;

    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = false;
    };

    displayManager = {
      sddm.enable = true;
      defaultSession = "plasma";
    };

    windowManager.icewm.enable = true;
  };

  services.packagekit.enable = true;

  programs = {
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
    ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  };

  environment = {
    etc."chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.plasma-browser-integration}/etc/chromium/native-messaging-hosts/org.kde.plasma.browser_integration.json";

    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    systemPackages = with pkgs; [
      konsave
      plasma-browser-integration
    ] ++ (if config.services.flatpak.enable
    then [
      kdePackages.discover
      kdePackages.packagekit-qt
      packagekit
    ]
    else [ ]);
  };
}

