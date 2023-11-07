{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.waybar.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    kitty
    mpd
    pavucontrol
    wofi
    zathura
  ];
}

