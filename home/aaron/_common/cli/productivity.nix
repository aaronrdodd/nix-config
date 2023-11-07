{ pkgs, ... }: {
  programs.taskwarrior = {
    enable = true;
  };

  home.packages = with pkgs; [
    qc
    qownnotes
    timer
    timewarrior
  ];
}

