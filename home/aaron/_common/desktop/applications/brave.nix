{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # keepassxc-browser
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # plasma-integration
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    ];
  };

  home.packages = with pkgs; [
    brave
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "brave.desktop" ];
      "text/xml" = [ "brave.desktop" ];
      "x-scheme-handler/http" = [ "brave.desktop" ];
      "x-scheme-handler/https" = [ "brave.desktop" ];
    };
  };
}

