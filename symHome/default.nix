{ pkgs, files ? {}}:
let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
in
  pkgs.writeScriptBin "symHome" (''
  #! /usr/bin/env sh
  PATH=${pkgs.coreutils}/bin
  set -e
  sym_home() {
    local src="$1"
    local dst="$HOME/$2"

    mkdir -p "$(dirname "$dst")"

    echo "Symlinking $2"
    ln -sf "$src" "$dst"
    }
''
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "sym_home \"${value}\" \"${name}\"")
    files
)
)
