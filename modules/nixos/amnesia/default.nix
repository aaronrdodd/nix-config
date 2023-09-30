{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.nixos.amnesia;

  btrfsWipeScript = ''
    mkdir --parents /tmp
    MNTPOINT=$(mktemp -d)

    (
      mount -t ${cfg.fileSystem} -o subvol=/ /dev/disk/by-partlabel/${cfg.fileSystemPartitionLabel} "$MNTPOINT"
      trap 'umount "$MNTPOINT"' EXIT

      btrfs subvolume list -o "$MNTPOINT/root" | cut -f9 -d ' ' |
      while read -r subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "$MNTPOINT/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
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
          "/var/lib/tailscale"
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
              passwordFile = "${cfg.baseDirectory}/passwords/${user}";
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
            "dev-disk-by\\x2dpartlabel-${cfg.fileSystemPartitionLabel}.device"
          ];
          after = [
            "dev-disk-by\\x2dpartlabel-${cfg.fileSystemPartitionLabel}.device"
            "systemd-cryptsetup@${cfg.fileSystemPartitionLabel}.service"
          ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = btrfsWipeScript;
        };
      };
    })
  ]);
}

