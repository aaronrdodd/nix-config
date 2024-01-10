# Disk layout examples
## Hybrid UEFI and MBR with ZFS (no encryption)

Suitable for use with the "zfs" impermanence option.

This configuration must be used with the grub bootloader.

```nix
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
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          acltype = "posixacl";
          atime = "off";
          canmount = "on";
          compression = "zstd";
          dedup = "on";
          devices = "off";
          mountpoint = "none";
          xattr = "sa";
        };

        datasets = {
          "DATA" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "ROOT" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "DATA/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          "ROOT/toplevel" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot zroot/ROOT/toplevel@blank
            '';
          };
          "ROOT/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "ROOT/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
          "ROOT/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
```

## Hybrid UEFI and MBR with ZFS (with encryption)

Suitable for use with the "zfs" impermanence option.

This configuration must be used with the grub bootloader.

```nix
{ disks ? [ "/dev/nvme0n1" ], ... }:
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
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          "com.sun:auto-snapshot" = "false";
          acltype = "posixacl";
          atime = "off";
          canmount = "on";
          compression = "zstd";
          dedup = "on";
          devices = "off";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          mountpoint = "none";
          xattr = "sa";
        };

        postCreateHook = ''
          zfs set keylocation=prompt zroot;
        '';

        datasets = {
          "DATA" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "ROOT" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "DATA/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
          };
          "ROOT/toplevel" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot zroot/ROOT/toplevel@blank
            '';
          };
          "ROOT/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options.mountpoint = "legacy";
          };
          "ROOT/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options.mountpoint = "legacy";
          };
          "ROOT/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
```
