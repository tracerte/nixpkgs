{ nixpkgs ? import <nixpkgs> {}, files ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
  dotfiles = files; 
in
nixpkgs.writeScriptBin "symHome" (''
  #! /usr/bin/env sh
  PATH=${nixpkgs.coreutils}/bin
  set -e
  update_dot() {
    local src="$1"
    local dst="$HOME/$2"

    mkdir -p "$(dirname "$dst")"

    echo "Updating $2"
    ln -sf "$src" "$dst"
    }
''
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "update_dot \"${value}\" \"${name}\"")
    dotfiles
)
)
