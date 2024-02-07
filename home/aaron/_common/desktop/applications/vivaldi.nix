{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    extensions = [
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # keepassxc-browser
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # plasma-integration
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    ];
  };

  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "vivaldi-stable.desktop" ];
      "text/xml" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
    };
  };
}

