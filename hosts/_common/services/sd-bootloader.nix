{
  boot.loader = {
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      editor = false;

      memtest86.enable = true;
      netbootxyz.enable = true;
    };
  };
}

