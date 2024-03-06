{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # keepassxc-browser
      { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # plasma-integration
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
    ];
  };

  home.packages = with pkgs; [
    chromium
  ];
}

