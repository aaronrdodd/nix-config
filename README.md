# Aaron's [NixOS] and [Home Manager] configurations

[![built with nix](https://img.shields.io/static/v1?logo=NixOS&logoColor=white&color=blue&label=&message=Built%20with%20Nix&style=for-the-badge)](https://builtwithnix.org)
[![flake-checker](https://img.shields.io/github/actions/workflow/status/aaron-dodd/nix-config/flake-checker.yml?label=flake%20checker&style=for-the-badge)](https://github.com/aaron-dodd/nix-config/actions/workflows/flake-checker.yml)
[![nix-checker](https://img.shields.io/github/actions/workflow/status/aaron-dodd/nix-config/nix-checker.yml?label=nix%20checker&style=for-the-badge)](https://github.com/aaron-dodd/nix-config/actions/workflows/nix-checker.yml)
[![script-checker](https://img.shields.io/github/actions/workflow/status/aaron-dodd/nix-config/script-checker.yml?label=script%20checker&style=for-the-badge)](https://github.com/aaron-dodd/nix-config/actions/workflows/script-checker.yml)

[NixOS]: https://nixos.org/
[Home Manager]: https://github.com/nix-community/home-manager

This repository contains a [Nix Flake](https://nixos.wiki/wiki/Flakes) for
configuring my computers and home environment.

Currently this configuration manages the following computers:

|    Hostname    |       OEM       |        Model        |       OS      |     Role     |  Status  |
| :------------: | :------------:  | :-----------------: | :-----------: | :----------: | :------- |
| `aetherius`    | Hewlett-Packard | AMD                 | NixOS         | Desktop      | WIP      |
| `vmware`       | VMware          | -                   | NixOS         | Desktop      | WIP      |

## Structure

- [.github]: GitHub CI/CD workflows.
- [home]: Home Manager configurations.
- [hosts](./hosts): NixOS machine configurations.
- [modules/home-manager]: Reusable Home Manager modules.
- [modules/nixos]: Reusable NixOS modules.
- [overlays]: NixOS package overrides.
- [packages]: Custom NixOS package definitions.
- [scripts]: Custom scripts.
- [secrets]: Secret files for both NixOS and Home Manager.
- [templates]: Custom Nix development environment definitions.

[.github]: ./.github/workflows
[home]: ./home
[modules/home-manager]: ./modules/home-manager
[modules/nixos]: ./modules/nixos
[overlays]: ./overlays
[packages]: ./packages
[scripts]: ./scripts
[secrets]: ./secrets
[templates]: ./templates

## How to's
### How to install the system

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

### How to make changes

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

### How to add a new computer

- Make sure you are within the nix-config git repository.

```bash
cd ~/nix-config
```

- Use `nixos-generate-config` to create a basic configuration for the
  computer.

```bash
sudo nixos-generate-config --no-filesystems --dir hosts/hostname
```

- Add a `default.nix` to source the configuration files from:

```bash
touch hosts/hostname/default.nix
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
      ./hosts/hostname
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

### How to set up SSH access

- Generate an ed25519 SSH key:

```bash
ssh-keygen -t ed25519
```

- **If the host should be able to interact with GitHub**: add the public key to
  your [GitHub SSH Configuration] as an *SSH key*.
- **If the host should be able to push commits to GitHub**: add the public key
  to the [GitHub SSH Configuration] as a *Signing key*, and also add it to
  the [`allowed_signers`] file.
- **If the host should be able to connect to other machines**: add the public
  key to `openssh.authorizedKeys.keys` to the [hosts user configuration].

[`allowed_signers`]: https://git-scm.com/docs/git-config#Documentation/git-config.txt-gpgsshallowedSignersFile
[GitHub SSH Configuration]: https://github.com/settings/keys
[hosts user configuration]: ./hosts/_common/users

### How to set up secrets

Secrets are managed using [mic92/sops-nix].

A bootstrap age key can be created with the following commands:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
```

or to convert an ssh ed25519 key to an age key:

```bash
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/<keyfile> > ~/.config/sops/age/keys.txt"
```

The age public key should be added to the [.sops.yaml] keys:

```yaml
keys:
  - &aaron_dodd 'age1dklej440dm807874vp2lrz7m72094s2v27autrhs7u0vjpxe75csttf2e0'
```

After first boot, generate an age public key from the host SSH key:

```bash
nix-shell -p ssh-to-age --run 'ssh-keyscan localhost | ssh-to-age'
```

Add a new section with this key to [.sops.yaml]:

```yaml
creation_rules:
  ...
  - path_regex: hosts/<hostname>/secrets(/[^/]+)?\.yaml$
    key_groups:
      - age:
          - *aaron-dodd
          - '<key>'
```

[mic92/sops-nix]: https://github.com/mic92/sops-nix
[.sops.yaml]: ./.sops.yaml

## TODO

- Rewrite the README.md
