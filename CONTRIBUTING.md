## Contributing to this nix-config

This document is for people who want to contribute to this nix-config. This
document assumes you know how to use GitHub and Git.

## How to's

### How to create pull requests
[pr-create]: #how-to-create-pull-requests

This section describes in some detail how changes can be made and proposed with pull requests.

> **Note**
> Be aware that contributing implies licensing those contributions under the terms of [LICENSE](./LICENSE).

0. Set up a local version of the repository.
   1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo#forking-a-repository) the [repository](https://www.github.com/aaron-dodd/nix-config).
   1. [Clone the forked repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#cloning-your-forked-repository) into a local directory.
   1. [Configure the upstream repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo#configuring-git-to-sync-your-fork-with-the-upstream-repository).

2. Create and switch to a new Git branch, ideally such that:
   - The name of the branch hints at the change you'd like to implement, e.g. `update-hello`.
   - The base of the branch includes the most recent changes on the base branch from step 1, we'll assume `main` here.

   ```bash
   # Make sure you have the latest changes from the upstream
   git fetch upstream

   # Create and switch to a new branch based off the upstream master branch
   git switch --create update-hello upstream/main
   ```

3. Make the desired changes in the local repository using an editor of your choice.
   Make sure to:
   - Adhere to the [code conventions][code-conventions].
   - Test the changes.
     See the [testing section][how-to-test-changes] for more specific information.
   - If necessary, document the change.

4. Commit your changes using `git commit`.
   Make sure to adhere to the [commit conventions](#commit-conventions).

   Repeat the steps 3-4 as many times as necessary.
   Advance to the next step if all the commits (viewable with `git log`) make sense together.

5. Push your commits to your fork of the repository.

6. [Create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request#creating-the-pull-request) from the new branch in your fork to the upstream repository.
   Use the branch from step 2 as the pull requests base branch.

## How to test changes
[how-to-test-changes]: #how-to-test-changes

You can test your changes by running the following commands:

1. To format and lint the nix code, run the following command:

```bash
nix fmt
```

2. To check the flake for issues, run the following command:

```bash
nix flake check
```

3. To test if the derivation builds successfully, run the following command 

```bash
sudo nixos-rebuild dry-activate --flake .#hostname
```

## Code conventions
[code-conventions]: #code-conventions

Follow the style enforced by `deadnix`, `statix`, and `nixpkgs-fmt`.

## Commit conventions
[commit-conventions]: #commit-conventions

We use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

```
chore: add automated build script
docs: explain how to contribute
feat: add beta sequence
fix: remove broken configuration
refactor: share logic between foobar and foobaz
style: convert tabs to spaces
test: ensure the code works
```

