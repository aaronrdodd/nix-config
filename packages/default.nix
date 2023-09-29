# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
{ pkgs ? (import ../nixpkgs.nix) { }, ... }: {
  bitwarden-secrets-sdk = pkgs.callPackage ./bitwarden-secrets-sdk { };
  nix-inspect = pkgs.callPackage ./nix-inspect { };
}

