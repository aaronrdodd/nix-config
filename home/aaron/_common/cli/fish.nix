{
  programs.fish = {
    enable = true;
    functions = {
      # Disable greeting
      fish_greeting = "";
    };
    shellAliases = {
      captive-portal = "xdg-open http://(ip --oneline route get 1.1.1.1 | awk '{print $3}')";
    };
  };
}

