# Aaron's [NixOS] and [Home Manager] configurations

[![flake-checker](https://github.com/aaron-dodd/nix-config/actions/workflows/flake-checker.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/flake-checker.yml)
[![nix-checker](https://github.com/aaron-dodd/nix-config/actions/workflows/nix-checker.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/nix-checker.yml)
[![script-checker](https://github.com/aaron-dodd/nix-config/actions/workflows/script-checker.yml/badge.svg)](https://github.com/aaron-dodd/nix-config/actions/workflows/script-checker.yml)

[NixOS]: https://nixos.org/
[Home Manager]: https://github.com/nix-community/home-manager

This repository contains a [Nix Flake](https://nixos.wiki/wiki/Flakes) for
configuring my computers and home environment.

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

- Download a [installation ISO](https://nixos.org/download) for NixOS.
- Put the ISO on a USB drive.
- Boot the computer using the USB drive.

Two installation options are available:

1. Install an ad-hoc system using the graphical installer, then rebuild to the
   flake-based configuration manually.
2. Run the following command to perform an automated installation:

```bash
curl -sL https://raw.githubusercontent.com/aaron-dodd/nix-config/main/scripts/install-system.sh > install-system.sh
chmod +x ./install-system.sh
./install-script.sh <hostname> <username>
```

where `<hostname>` is the name of the machine you want to install, and
`<username>` is the user to use for administrative configuration purposes.

The automated installation will wipe all data on the disks and will need to be
`reboot`ed once it finishes.

## Making changes

- Clone the repository to your home directory using Git if you don't have it
  already:

```bash
git clone https://github.com/aaron-dodd/nix-config.git
```

- Edit the nix files.
- Changes can be tested using:

```bash
cd ~/nix-config
nix fmt
nix flake check
sudo nixos-rebuild dry-activate --flake .
```

- Changes can be applied using:

```bash
sudo nixos-rebuild switch --flake ~/nix-config
```

You can use `boot` instead of `switch` to enter the new configuration on
reboot.

## Adding a new computer

- Make sure you are within the nix-config git repository.

```bash
cd ~/nix-config
```

- Use `nixos-generate-config` to create a basic configuration for the
  computer.

```bash
sudo nixos-generate-config --no-filesystems --dir nixos/hostname
```

- Add a `default.nix` to source the configuration files from:

```bash
touch nixos/hostname/default.nix
```

`default.nix` should look like this:

```nix
{
  imports = [
    ./configuration.nix
  ];
}
```

- Edit `configuration.nix` to your liking.
- Add a basic home-manager configuration for the computer.

```bash
touch home/aaron/hostname.nix
```

`hostname.nix` should at minimum include:

```nix
{
  imports = [
    ./_common/global
  ];
}
```

- Edit `hostname.nix` to your liking.
- Add the computer to `flake.nix`:

```nix
# omitted for brevity ...

nixosConfigurations = {
  hostname = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs outputs; };
    modules = [
      ./nixos/hostname
    ];
  };
};

# omitted for brevity ...
```

- Test changes by running the following:

```bash
nix fmt
nix flake check
sudo nixos-rebuild dry-activate --flake .#hostname
```

- Update `README.md` with information about the computer.
- Commit and push changes.

## Setting up SSH access

- Generate an ed25519 SSH key:

```bash
ssh-keygen -t ed25519
```

- **If the host should be able to interact with GitHub**: add the public key to
  your [GitHub SSH Configuration] as an *SSH key*.
- **If the host should be able to push commits to GitHub**: add the public key
  to the [GitHub SSH Configuration] as a *Signing key*, and also add it to
  the `allowed_signers` file.
- **If the host should be able to connect to other machines**: add the public
  key to `openssh.authorizedKeys.keys` to the [nixos user configuration].

[GitHub SSH Configuration]: https://github.com/settings/keys
[nixos user configuration]: ./nixos/_common/users

