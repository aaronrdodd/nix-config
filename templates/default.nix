# Custom development environment templates,
# You can find many examples here: https://github.com/the-nix-way/dev-templates
# You can initialise them using 'nix flake init'.
{
  csharp = {
    description = "A Nix-flake-based C# development environment";
    path = ./csharp;
  };

  go = {
    description = "A Nix-flake-based Go development environment";
    path = ./go;
  };

  latex = {
    description = "A Nix-flake-based Latex development environment";
    path = ./latex;
  };

  node = {
    description = "A Nix-flake-based Node development environment";
    path = ./node;
  };

  rust = {
    description = "A Nix-flake-based Rust development environment";
    path = ./rust;
  };

  rust-toolchain = {
    description = "A Nix-flake-based Rust Toolchain development environment";
    path = ./rust-toolchain;
  };
}

