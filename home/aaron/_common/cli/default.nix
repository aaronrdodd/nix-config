{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./gh.nix
    ./nix-index.nix
    ./productivity.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator

    nix-inspect # Inspect the path when in a nix environment

    wormhole-william # Send files between computers
  ];
}
