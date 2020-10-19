# Nixpkgs

## Instructions

First clone this repo into your `~/.config` directory.

Choose an overlay to install.

```sh
$ nix-env -Air nixos.achilles
```

Install files (usually dotfiles) into home folder:

```sh
$ symHome
```

Install Fonts:

```sh
$ updateFonts
```

## How To's

Some common tasks that are not exactly obvious.

### Generate a sha256 for Remotely Downloaded Source Code

When creating derivations that use remotely downloaded source, you need to populate the `sha256` field.

Use a version of `nix-prefetch-`, like:
- `nix-prefetch-url`
- `nix-prefetch-git`
- `nix-prefetch-github`

For tarballs:

```sh
$ nix-prefetch-url --unpack <url>.tar.gz
```
