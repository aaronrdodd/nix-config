{ pkgs, lib, ... }: {
  services.flatpak.enable = true;

  systemd.services.configure-flathub-repo = {
    after = [ "network-online.target" "systemd-resolved.service" ];
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

  xdg.portal.enable = lib.mkForce true;
}

