{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.nixos.amnesia;
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
    {
      fileSystems.${cfg.baseDirectory}.neededForBoot = true;

      # cfg.baseDirectory is the location you plan to store the files
      environment.persistence.${cfg.baseDirectory} = {
        # Hide these mount from the sidebar of file managers
        hideMounts = true;

        # Folders you want to map
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/containers"
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
      users.users = mkMerge ([{ root.passwordFile = "${cfg.baseDirectory}/passwords/root"; }] ++
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
    (mkIf config.nixos.oci-containers.enable {
      nixos.oci-containers.volumeBaseDir = "${cfg.baseDirectory}/container-volumes";
    })
    (mkIf (cfg.fileSystem == "btrfs") {
      # Note `mkBefore` is used instead of `mkAfter` here.
      boot.initrd.postDeviceCommands = mkBefore ''
        mkdir --parents /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -t ${cfg.fileSystem} -o subvol=/ /dev/disk/by-partlabel/${cfg.fileSystemPartitionLabel} /mnt

        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';
    })
  ]);
}

