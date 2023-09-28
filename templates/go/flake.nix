{
  description = "A Nix-flake-based Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # deadnix: skip
  outputs = { self, nixpkgs }:
    let
      goVersion = 20; # Change this to update the whole stack
      overlays = [ (_final: prev: { go = prev."go_1_${toString goVersion}"; }) ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # go (specified by overlay)
            go

            # goimports, godoc, etc.
            gotools

            # https://github.com/golangci/golangci-lint
            golangci-lint
          ];
        };
      });
    };
}

