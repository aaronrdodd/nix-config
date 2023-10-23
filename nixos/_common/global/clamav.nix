{
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  systemd.services.create-clamav-cache = {
    description = "Create cache directory for clamav";
    enable = true;
    wantedBy = [ "clamav-daemon.service" ];
    serviceConfig = {
      type = "oneshot";
    };
    script = ''
      mkdir -p /var/lib/clamav
      chown -R clamav:clamav /var/lib/clamav
    '';
  };
}

