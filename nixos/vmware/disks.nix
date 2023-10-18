{ disks ? [ "/dev/sda" ], ... }:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              priority = 1;
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              priority = 2;
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                postCreateHook = ''
                  MNTPOINT=$(mktemp -d)
                  trap 'umount $MNTPOINT/root; umount $MNTPOINT; rm -rf $MNTPOINT' EXIT

                  mount /dev/disk/by-partlabel/disk-main-root $MNTPOINT -o subvol=/
                  mount /dev/disk/by-partlabel/disk-main-root $MNTPOINT/root -o subvol=/root
                  btrfs subvolume snapshot -r "$MNTPOINT/root" "$MNTPOINT/root-blank"
                '';
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                  };
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                  "/persist" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/persist";
                  };
                  "/tmp" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/tmp";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
    ];
  };
}

