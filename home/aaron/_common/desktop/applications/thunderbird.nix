{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird
    protonmail-bridge
  ];

  systemd.user.services.protonmail-bridge = {
    Unit = {
      Description = "ProtonMail bridge service";
    };
    Service = {
      ExecStart = ''
        ${pkgs.protonmail-bridge}/bin/protonmail-bridge \
          --log-level info \
          --noninteractive
      '';
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

