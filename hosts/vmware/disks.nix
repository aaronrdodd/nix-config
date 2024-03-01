{ disks ? [ "/dev/sda" ], ... }: {
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
              type = "EF02"; # For Grub MBR
            };
            ESP = {
              priority = 2;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0077" "dmask=0077" ];
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "filesystem";
                extraArgs = [ "-f" ];
                format = "xfs";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

