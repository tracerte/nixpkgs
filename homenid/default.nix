{ nixpkgs ? import <nixpkgs> {}, files ? {}, services ? {}, fonts ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
in
nixpkgs.writeScriptBin "homenid" (''
  #! /usr/bin/env bash
  set -e

  declare -A fileDB
  declare -A fontDB
  declare -A serviceDB
  configDir="$HOME/.homenid"
  fileDBFile="fileDB.sh"
  serviceDBFile="serviceDB.sh"
  fontDBFile="fontDB.sh"

  setup(){
    mkdir -p "$configDir"
    touch "$configDir/$fileDBFile" 
    touch "$configDir/$fontDBFile" 
    touch "$configDir/$serviceDBFile" 
    }
  # arg1: db to write
  # arg2: file to write db
  # arg3: serialized db name 
  writeDB(){
    eval "declare -A $3="''${1#*=}
    declare -p "$3" > "$configDir/$2"
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
    source -- "$configDir/$fileDBFile"
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
    declare -A serializedFontDB
    source -- "$configDir/$fontDBFile"
    if [[ ''${serializedFontDB["$fontDst/$1"]} ]]; then
      if [[ ''${serializedFontDB["$fontDst/$1"]} == "$2" ]]; then
        echo "Skipping font $1, has not changed"
      else
        echo "Updating font(s)"
        sym "$fontDst" "$2"
        echo "Updating font cache"
        fc-cache
      fi
    else
      echo "Installing new font(s)"
      sym "$fontDst" "$2"
      echo "Updating font cache"
      fc-cache
    fi
    echo "Writing $1 to db"
    fontDB["$fontDst/$1"]+="$2"
  }
  # arg1: serviceName
  # arg2: serviceSrc
  service () {
    local serviceDst="$HOME/.config/systemd/user/$1"
    declare -A serializedServiceDB
    source -- "$configDir/$serviceDBFile"
    if [[ ''${serializedServiceDB["$serviceDst"]} ]]; then
      if [[ ''${serializedServiceDB["$serviceDst"]} == "$2" ]]; then
        echo "Skipping service $1, has not changed"
      else
        echo "Updating service(s)"
        sym "$serviceDst" "$2"
        systemctl --user daemon-reload
        echo "Enabling service $1"
        systemctl --user enable "$1"
        fi
    else
      echo "Installing new service(s)"
      sym "$serviceDst" "$2"
      systemctl --user daemon-reload
      echo "Enabling service $1"
      systemctl --user enable "$1"
    fi
    echo "Writing $1 to db"
    serviceDB["$serviceDst"]+="$2"
  }

setup
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
# See https://stackoverflow.com/a/8879444 for details on passing bash associative arrays to functions
writeDB "''$(declare -p fileDB)" "$fileDBFile" "serializedFileDB"
writeDB "''$(declare -p fontDB)" "$fontDBFile" "serializedFontDB"
writeDB "''$(declare -p serviceDB)" "$serviceDBFile" "serializedServiceDB"
''
)
