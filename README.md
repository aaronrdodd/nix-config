# Aaron's [NixOS] and [Home Manager] configurations

[![code-analysis](https://github.com/aaron-dodd/nix-config/actions/workflows/code-analysis.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/code-analysis.yml)
[![flake-checker](https://github.com/aaron-dodd/nix-config/actions/workflows/flake-checker.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/flake-checker.yml)
[![script-checker](https://github.com/aaron-dodd/nix-config/actions/workflows/script-checker.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/script-checker.yml)

[NixOS]: https://nixos.org/
[Home Manager]: https://github.com/nix-community/home-manager

This repository contains a [Nix Flake](https://nixos.wiki/wiki/Flakes) for configuring my computers and home environment.

Currently this configuration manages the following computers:

|    Hostname    |       OEM      |        Model        |       OS      |     Role     |  Status  |
| :------------: | :------------: | :-----------------: | :-----------: | :----------: | :------- |
| `vmware`       | VM             | -                   | NixOS         | Desktop      | WIP      |

## Structure

 - [.github]: GitHub CI/CD workflows.
 - [home]: Home Manager configurations.
 - [modules/home-manager]: Reusable Home Manager modules.
 - [modules/nixos]: Reusable NixOS modules.
 - [nixos](./nixos): NixOS machine configurations.
 - [overlays]: NixOS package overrides.
 - [packages]: Custom NixOS package definitions.
 - [scripts]: Custom scripts.
 - [templates]: Custom Nix development environment definitions.

[.github]: ./.github/workflows
[home]: ./home
[modules/home-manager]: ./modules/home-manager
[modules/nixos]: ./modules/nixos
[overlays]: ./overlays
[packages]: ./packages
[scripts]: ./scripts
[templates]: ./templates

## Installation

You can install the base system by booting into a NixOS ISO and running the
following command:

```bash
curl -sL https://raw.githubusercontent.com/aaron-dodd/nix-config/main/scripts/install-system.sh > install-system.sh
chmod +x ./install-system.sh
./install-script.sh <hostname> <username>
```

where `<hostname>` is the name of the machine you want to install, and
`<username>` is the user to use for administrative purposes.

