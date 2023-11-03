{ pkgs, ... }: {
  programs.sway = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    foot
    kitty
    mpd
    pavucontrol
    wofi
    zathura
  ];
}

