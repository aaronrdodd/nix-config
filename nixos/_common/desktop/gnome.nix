{ config, pkgs, ... }: {
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # Enable dconf
  programs.dconf.enable = true;

  # Disable xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Disable gnome core utilities
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
  ];

  services.gnome.core-utilities.enable = false;
  services.gnome.gnome-keyring.enable = true;

  # Add desktop packages
  environment.systemPackages = with pkgs; [
    amberol
    blackbox-terminal
    evince
    firefox-esr
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    gnome.nautilus
    gradience
    vlc
  ] ++ (if config.services.flatpak.enable then [ gnome.gnome-software ] else [ ]);

  programs = {
    gnome-disks.enable = true;
    seahorse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}

