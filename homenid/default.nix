{ nixpkgs ? import <nixpkgs> {}, files ? {}, services ? {}, fonts ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
in
nixpkgs.writeScriptBin "homenid" (''
  #! /usr/bin/env bash
  set -e
  
  # arg1: dest
  # arg2: src (file or dir)
  sym() {
    local dst="$1"
    local src="$2"

    if [[ -d $src ]]; then
      mkdir -p "$dst"
      local src_dir=$2
      echo "Symlinking directory $src_dir"
      for file in "$src_dir"/*
      do
        ln -sf "$src_dir"/"$(basename "$file")" "$dst"/"$(basename "$file")"
      done
    elif [[ -f $src ]]; then
      mkdir -p "$(dirname "$dst")"
      echo "Symlinking file $1"
      ln -sf "$src" "$dst"
    else
      echo "$2 is not a valid file or directory"
      exit 1
    fi
    }
  # arg1: fileName
  # arg2: fileSrc
  file() {
    local fileDst="$HOME/$1"
    echo "Bootstrapping file(s)"
    sym "$fileDst" "$2"
  }
  # arg1: fontName
  # arg2: fontSrc
  font() {
    local fontDst="$HOME/.local/share/fonts"
    echo "Bootstrapping font $1"
    sym "$fontDst" "$2"
    echo "Updating font cache"
    fc-cache
  }
  # arg1: serviceName
  # arg2: serviceSrc
  service () {
    local serviceDst="$HOME/.config/systemd/user/$1"
    echo "Bootstrapping systemd service file $1"
    sym "$serviceDst" "$2"
    systemctl --user daemon-reload
    echo "Enabling service $1"
    systemctl --user enable "$1"
  }
''
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "file \"${name}\" \"${value}\"")
    files
)
+
"\n"
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "font \"${name}\" \"${value}\"")
    fonts
)
+
"\n"
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "service \"${name}\" \"${value}\"")
    services
)
)
