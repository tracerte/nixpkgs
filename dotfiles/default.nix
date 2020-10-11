{ pkgs, files ? {}}:
let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
  dotfiles = files; 
in
pkgs.writeScriptBin "updateDotFiles" (''
  #! /usr/bin/env sh
  PATH=${pkgs.coreutils}/bin
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
