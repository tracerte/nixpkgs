{ nixpkgs ? import <nixpkgs> {}, files ? {}, services ? {}, fonts ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
  serviceHome = "${home}/.config/systemd/user";
  fontsHome = "${home}/.local/share/fonts";
  filesTBI = toString (lib.mapAttrsToList(name: value: "${name}") files);
  servicesTBI = toString (lib.mapAttrsToList(name: value: "${name}") services);
  fontsTBI = toString (lib.mapAttrsToList(name: value: "${name}") fonts);
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

  # run setup
  setup(){
    mkdir -p "$configDir"
    touch "$configDir/$fileDBFile" 
    touch "$configDir/$fontDBFile" 
    touch "$configDir/$serviceDBFile" 
    }
  setup

  filesTBI=("${filesTBI}")
  fontsTBI=("${fontsTBI}")
  servicesTBI=("${servicesTBI}")
  declare -A serializedFileDB
  source -- "$configDir/$fileDBFile"
  declare -A serializedFontDB
  source -- "$configDir/$fontDBFile"
  declare -A serializedServiceDB
  source -- "$configDir/$serviceDBFile"

  die() {
    [ $# -gt 0 ] && printf -- "%s\n" "$*"
    exit 1
  }
  # arg1: db
  # arg2: tbi
  # arg3: cleanup function
  cleanup(){
    local -n db=$1
    local -n tbi=$2
    local func=$3
    for e in "''${!db[@]}"
    do
      if [[ ! " ''${tbi[@]} " =~ "$e" ]]; then
        echo "No longer managing $e, removing it"
        $func "$e"
      fi
    done
  }

  dummyRemove(){
    echo "Removing $1"
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

  # arg1: item name
  # arg2: item dest
  # arg3: item src
  # arg4: item installation function
  # arg5: item db
  # arg6: item serialized db
  initialize() {
    local name=$1
    local dst=$2
    local src=$3
    local func=$4
    local -n db=$5
    local -n serializedDB=$6
    if [[ ''${serializedDB["$name"]} ]]; then
      if [[ ''${serializedDB["$name"]} == "$src" ]]; then
        echo "Skipping item $name, has not changed"
      else
        echo "Updating item(s)"
        $func "$dst" "$src"
      fi
    else
      echo "Installing new item(s)"
        $func "$dst" "$src"
    fi
    echo "Writing $name to db"
    db["$name"]+="$src"
  }


  # arg1: file destination
  # arg2: file source
  installFile(){
    sym "$1" "$2"
  }

  # arg1: file name
  removeFile(){
    local fileDst="$HOME/$1"
    read -p "Are you sure you want to delete $fileDst? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]];then 
      echo "Deleting $fileDst"
      rm "$fileDst"
    else
      echo "Skipping the removal of $1"
      die "Aborted"
    fi
  }
  # arg1: fileName
  # arg2: fileSrc
  file() {
    local fileDst="$HOME/$1"
    echo "Initializing files"
    initialize $1 $fileDst $2 "installFile" fileDB serializedFileDB    
  }


  # arg1: font destination
  # arg2: font source
  installFont() {
    sym "$1" "$2"
    echo "Updating font cache"
    fc-cache
  }

  # arg1: font name to match
  removeFont(){
    shopt -s nocaseglob
    local font="$HOME/.local/share/fonts/$1"
    echo "These fonts matched the name $1 given and are pending deletion, please review them:"
    ls $font*
    read -p "Are you sure you want to delete these fonts? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]];then 
      echo "Deleting the listed fonts"
      rm $font*
      fc-cache
    else
      echo "Skipping the removal of $1"
      die "Aborted"
    fi
  }
  # arg1: fontName
  # arg2: fontSrc
  font() {
    local fontDst="$HOME/.local/share/fonts"
    echo "Initializing font"
    initialize $1 $fontDst $2 "installFont" fontDB serializedFontDB 
  }

  # arg1: service destination
  # arg2: service source
  installService(){
    local name="$(basename $1)"
    sym "$1" "$2"
    systemctl --user daemon-reload
    echo "Enabling service $name"
    systemctl --user enable "$name"
  }

  # arg1: service name
  removeService(){
    local name=$1 
    read -p "Are you sure you want to delete $name? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]];then 
      echo "Stopping service $name"
      systemctl --user stop "$name"
      echo "Disabling service $name"
      systemctl --user disable "$name"
      systemctl --user daemon-reload
    else
      echo "Skipping the removal of $name"
      die "Aborted"
    fi
  }

  # arg1: serviceName
  # arg2: serviceSrc
  service () {
    local serviceDst="$HOME/.config/systemd/user/$1"
    echo "Initializing service"
    initialize $1 $serviceDst $2 "installService" serviceDB serializedServiceDB 
    }

  cleanup serializedFileDB filesTBI "removeFile"
  cleanup serializedFontDB fontsTBI "removeFont"
  cleanup serializedServiceDB servicesTBI "removeService"
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
