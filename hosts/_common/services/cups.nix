{ pkgs, ... }: {
  imports = [
    ./avahi.nix
  ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };
}

