# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let
  disk = "/dev/sda";
  hostName = "vmware";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ./disks.nix { })
    (import ../_common/services/grub-bootloader.nix { devices = [ disk ]; })

    ../_common/global
    ../_common/desktop/gnome.nix
    ../_common/services/amnesia.nix
    ../_common/services/dns-security.nix
    ../_common/services/flatpak.nix
    ../_common/services/localisation.nix
    ../_common/services/mosh.nix
    ../_common/services/oci-containers.nix
    ../_common/services/pipewire.nix
    ../_common/services/printing.nix
    ../_common/services/tailscale.nix
    ../_common/users/aaron
  ];

  networking.hostName = hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable guest additions
  virtualisation.vmware.guest.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

