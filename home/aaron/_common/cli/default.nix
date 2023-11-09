{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./gh.nix
    ./nix-index.nix
    ./productivity.nix
    ./skim.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    bc # Calculator
    bottom # System viewer
    comma # Install and run programs by sticking a , before them
    diffsitter # Better diff
    distrobox # Nice escape hatch, integrates docker images with my environment
    fd # Better find
    fzf # Fuzzy finder
    httpie # Better curl
    jq # JSON pretty printer and manipulator
    ncdu # TUI disk usage
    nix-inspect # Inspect the path when in a nix environment
    ripgrep # Better grep
    sd # Sed replacement
  ];
}
