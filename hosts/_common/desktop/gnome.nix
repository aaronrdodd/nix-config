{ config, pkgs, ... }: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    gnome-disks.enable = true;
    seahorse.enable = true;
  };

  # Enable the GNOME Desktop Environment and disable xterm
  services = {
    gnome = {
      core-utilities.enable = false;
      gnome-keyring.enable = true;
      sushi.enable = true;
    };

    gvfs.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;

      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };

      windowManager.icewm.enable = true;
      excludePackages = [ pkgs.xterm ];
    };
  };


  # Disable gnome core utilities
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  # Add desktop packages
  environment.systemPackages = with pkgs; [
    blackbox-terminal
    evince
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.kimpanel
  ] ++ (if config.services.flatpak.enable then [ gnome.gnome-software ] else [ ]);
}

