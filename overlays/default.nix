# This file defines overlays
{ inputs, ... }:
{
  nur = inputs.nur.overlay;

  # This one brings our custom packages from the 'packages' directory
  additions = final: _prev: import ../packages { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    exa = inputs.eza.packages.${final.system}.default.overrideAttrs (oldAttrs: {
      postInstall = oldAttrs.postInstall + ''
        ln -sv $out/bin/eza $out/bin/exa
      '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };

  # When applied, the master nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.master'
  master-packages = final: _prev: {
    master = import inputs.nixpkgs-master {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}

