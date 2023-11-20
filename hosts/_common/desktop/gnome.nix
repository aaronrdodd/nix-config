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
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager = {
      gnome.enable = true;
      xterm.enable = false;
    };

    excludePackages = [ pkgs.xterm ];
  };


  # Disable gnome core utilities
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-keyring.enable = true;

  # Add desktop packages
  environment.systemPackages = with pkgs; [
    blackbox-terminal
    evince
    firefox-esr
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.appindicator
    gnomeExtensions.forge
    gradience
    vlc
  ] ++ (if config.services.flatpak.enable then [ gnome.gnome-software ] else [ ]);
}

