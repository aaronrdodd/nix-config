{ pkgs
, ...
}:
let
  pname = "bitwarden-secrets-manager-sdk";
  version = "0.3.0";
in

with pkgs;

rustPlatform.buildRustPackage {
  inherit pname;
  inherit version;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "bws-v${version}";
    hash = "sha256-o+tmO9E881futhA/fN6+EX2yEBKnKUmKk/KilIt5vYY=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config python310 ];

  cargoSha256 = "sha256-bCV9i87IhqB6jxtnkgYpvluoT8YOjKwx8viajrB5u18=";

  meta = {
    changelog = "https://github.com/bitwarden/sdk/releases/tag/${src.rev}";
    description = "Bitwarden Secrets Manager SDK";
    homepage = "https://bitwarden.com";
    mainProgram = "bws";
  };
}
