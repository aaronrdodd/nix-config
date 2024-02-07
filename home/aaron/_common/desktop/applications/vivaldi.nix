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
      "text/html" = [ "chromium-browser.desktop" ];
      "text/xml" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
      "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
    };
  };
}

