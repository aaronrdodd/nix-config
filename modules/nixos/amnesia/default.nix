{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.nixos.amnesia;

  clamavEnabled = config.services.clamav.daemon.enable;
  plasmaEnabled = config.services.xserver.desktopManager.plasma5.enable;

  btrfsWipeScript = ''
    mkdir --parents /tmp
    MNTPOINT=$(mktemp -d)

    (
      mount -t ${cfg.fileSystem} -o subvol=/ /dev/disk/by-partlabel/${cfg.fileSystemPartitionLabel} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
      while read -r subvolume; do
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done &&
      btrfs subvolume delete "$MNTPOINT/root"

      btrfs subvolume snapshot "$MNTPOINT/root-blank" "$MNTPOINT/root"
    )
  '';

  phase1Systemd = config.boot.initrd.systemd.enable;

in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.nixos.amnesia = {
    enable = mkOption {
      type = types.bool;
      description = "Whether to enable the amnesiac configuration.";
      default = false;
    };
    baseDirectory = mkOption {
      type = types.path;
      description = "The base directory to store persistent state.";
      default = "/persist";
    };
    users = mkOption {
      type = types.listOf types.str;
      description = "Users to map password files for.";
      default = [ "aaron" ];
    };
    fileSystem = mkOption {
      type = types.enum [ "btrfs" "zfs" ];
      default = "btrfs";
    };
    fileSystemPartitionLabel = mkOption {
      type = types.str;
      default = "disk-main-root";
    };
    fileSystemDeviceLabel = mkOption {
      type = types.str;
      description = "Should be equivalent to '${cfg.fileSystemPartitionLabel}'. Replace any '-' with '\\x2d' for systemd escaping.";
      default = "disk\\x2dmain\\x2droot";
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Common settings
    {
      fileSystems.${cfg.baseDirectory}.neededForBoot = true;

      # cfg.baseDirectory is the location you plan to store the files
      environment.persistence.${cfg.baseDirectory} = {
        # Hide these mount from the sidebar of file managers
        hideMounts = true;

        # Folders you want to map
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/log"
        ];

        files = [
          "/etc/data.keyfile"
          "/etc/machine-id"
        ];
      };

      # Persisting user passwords
      users.mutableUsers = mkForce false;
      users.users = mkMerge (
        forEach cfg.users (user:
          {
            "${user}" = {
              initialPassword = mkForce null;
              hashedPasswordFile = "${cfg.baseDirectory}/passwords/${user}";
            };
          }
        )
      );
    }

    # OpenSSH
    (mkIf config.services.openssh.enable {
      # cfg.baseDirectory is the location you plan to store the files
      environment.persistence.${cfg.baseDirectory} = {
        files = [
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
        ];
      };

      services.openssh.hostKeys = mkForce [
        {
          path = "${toString cfg.baseDirectory}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "${toString cfg.baseDirectory}/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    })

    # OCI Containers
    (mkIf config.nixos.oci-containers.enable (mkMerge [
      {
        nixos.oci-containers.volumeBaseDir = "${cfg.baseDirectory}/container-volumes";
      }
      (mkIf (config.nixos.oci-containers.backend == "docker") {
        environment.persistence.${cfg.baseDirectory}.directories = [
          "/var/lib/docker"
        ];

        programs.fuse.userAllowOther = true;
      })
      (mkIf (config.nixos.oci-containers.backend == "podman") {
        environment.persistence.${cfg.baseDirectory}.directories = [
          "/var/lib/containers"
        ];
      })
    ]))

    # Flatpak
    (mkIf config.services.flatpak.enable {
      environment.persistence.${cfg.baseDirectory}.directories = [
        "/var/lib/flatpak"
      ];
    })

    # Tailscale
    (mkIf config.services.tailscale.enable {
      environment.persistence.${cfg.baseDirectory}.directories = [
        "/var/lib/tailscale"
      ];
    })

    # Plasma
    (mkIf plasmaEnabled {
      environment.persistence.${cfg.baseDirectory}.directories = [
        "/var/lib/sddm"
      ];
    })

    # Clamav
    (mkIf clamavEnabled {
      environment.persistence.${cfg.baseDirectory}.directories = [
        "/var/lib/clamav"
      ];
    })

    # BTRFS filesystems
    (mkIf (cfg.fileSystem == "btrfs") {
      # Note `mkBefore` is used instead of `mkAfter` here.
      boot.initrd = {
        supportedFilesystems = [ "btrfs" ];
        postDeviceCommands = mkIf (!phase1Systemd) (mkBefore btrfsWipeScript);
        systemd.services.restore-root = lib.mkIf phase1Systemd {
          description = "Rollback btrfs rootfs";
          wantedBy = [ "initrd.target" ];
          requires = [
            "dev-disk-by\\x2dpartlabel-${cfg.fileSystemDeviceLabel}.device"
          ];
          after = [
            "dev-disk-by\\x2dpartlabel-${cfg.fileSystemDeviceLabel}.device"
            "systemd-cryptsetup@${cfg.fileSystemDeviceLabel}.service"
          ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = btrfsWipeScript;
        };
      };
    })

    # ZFS filesystems
    (mkIf (cfg.fileSystem == "zfs") {
      boot.initrd = {
        supportedFilesystems = [ "zfs" ];
        postDeviceCommands = lib.mkAfter ''
          zfs rollback -r zroot/ROOT/toplevel@blank
        '';
      };
    })
  ]);
}
