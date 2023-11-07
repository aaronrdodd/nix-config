{ devices ? [ ] }:
{
  # replace this with your disk i.e. /dev/nvme0n1
  boot.loader.grub = {
    inherit devices;

    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}

