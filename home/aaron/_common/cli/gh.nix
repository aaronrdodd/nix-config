{ pkgs, ... }: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  home.packages = with pkgs; [
    glab
  ];
}

