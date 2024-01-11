{
  description = "Aaron's NixOS and Home Manager configuration";

  inputs = {
    # Pick a release channel from here
    # https://status.nixos.org
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-23.05";
    };
    nixpkgs-master = {
      url = "github:nixos/nixpkgs";
    };

    # Hardware profiles
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # Disk configuration and partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk erasure
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # Home directory configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;

      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});

      # Custom development environment templates
      # Accessible through 'nix flake init', 'nix flake new' etc
      # You can find many examples here: https://github.com/the-nix-way/dev-templates
      templates = import ./templates;

      # Formatter for your nix files
      # Accessible through 'nix fmt'
      formatter = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.writeShellApplication {
          name = "nix-flake-format";
          runtimeInputs = with pkgs; [
            nixpkgs-fmt
            deadnix
            statix
          ];
          text = ''
            set -o xtrace

            deadnix --edit "$@"

            for i in "$@"; do
              ${pkgs.statix}/bin/statix fix "$i"
            done

            nixpkgs-fmt "$@"
          '';
        }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs outputs; };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;

      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # Devshell for bootstrapping, acessible via 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        aetherius = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/aetherius
          ];
        };
        vmware = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/vmware
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "aaron@aetherius" = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/aaron/aetherius.nix
          ];
          extraSpecialArgs = { inherit inputs outputs; };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        };
        "aaron@vmware" = home-manager.lib.homeManagerConfiguration {
          modules = [
            ./home/aaron/vmware.nix
          ];
          extraSpecialArgs = { inherit inputs outputs; };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        };
      };

      wallpapers = import ./home/aaron/_common/wallpapers;
    };
}

