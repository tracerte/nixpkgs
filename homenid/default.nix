{ nixpkgs ? import <nixpkgs> {}, files ? {}, services ? {}, fonts ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
in
nixpkgs.writeScriptBin "homenid" (''
  #! /usr/bin/env bash
  set -e

  declare -A fileDB
  configDir="$HOME/.homenid"
  fileDBFile="$configDir/fileDB.sh"
  serviceDBFile="$configDir/serviceDB.sh"
  fontDBFile="$configDir/fontDB.sh"

  writeFileDB(){
    mkdir -p "$configDir"
    declare -A serializedFileDB
    for k in "''${!fileDB[@]}"; do serializedFileDB[$k]=''${fileDB[$k]}; done
    declare -p serializedFileDB > "$fileDBFile"
  }
  
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
    declare -A serializedFileDB
    source -- "$fileDBFile"
    if [[ ''${serializedFileDB["$fileDst"]} ]]; then
      if [[ ''${serializedFileDB["$fileDst"]} == "$2" ]]; then
        echo "Skipping file $1, has not changed"
      else
        echo "Updating file(s)"
        sym "$fileDst" "$2"
      fi
    else
      echo "Installing new file(s)"
      sym "$fileDst" "$2"
    fi
    echo "Writing $1 to db"
    fileDB["$fileDst"]+="$2"
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
+
"\n"
+
''
writeFileDB
''
)
