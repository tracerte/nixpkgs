{ nixpkgs ? import <nixpkgs> {}, files ? {}, services ? {}, fonts ? {}}:
let
  lib = nixpkgs.lib;
  home = builtins.getEnv "HOME";
  serviceHome = "${home}/.config/systemd/user";
  fontsHome = "${home}/.local/share/fonts";
  filesTBI = toString (lib.mapAttrsToList(name: value: "${home}/${name}") files);
  servicesTBI = toString (lib.mapAttrsToList(name: value: "${serviceHome}/${name}") services);
  fontsTBI = toString (lib.mapAttrsToList(name: value: "${fontsHome}/${name}") fonts);
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

  cleanupFiles(){
    for fileInDB in "''${!serializedFileDB[@]}"
    do
      if [[ ! " ''${filesTBI[@]} " =~ "$fileInDB" ]]; then
        echo "No longer managing file $fileInDB, removing it"
        removeFile "$fileInDB"
      fi
    done
  }
  cleanupServices(){
    for serviceInDB in "''${!serializedServiceDB[@]}"
    do
      if [[ ! " ''${servicesTBI[@]} " =~ "$serviceInDB" ]]; then
        echo "No longer managing service $serviceInDB, removing it"
        removeService "$serviceInDB"
      fi
    done
  }
  cleanupFonts(){
    for fontInDB in "''${!serializedFontDB[@]}"
    do
      if [[ ! " ''${fontsTBI[@]} " =~ "$fontInDB" ]]; then
        echo "No longer managing font $fontInDB, removing it"
        removeFont "$fontInDB"
      fi
    done
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

  # arg1: file destination
  # arg2: file source
  installFile(){
    sym "$1" "$2"
  }

  # arg1: file location
  removeFile(){
    rm "$1"
  }
  # arg1: fileName
  # arg2: fileSrc
  file() {
    local fileDst="$HOME/$1"
    if [[ ''${serializedFileDB["$fileDst"]} ]]; then
      if [[ ''${serializedFileDB["$fileDst"]} == "$2" ]]; then
        echo "Skipping file $1, has not changed"
      else
        echo "Updating file(s)"
        installFile "$fileDst" "$2"
      fi
    else
      echo "Installing new file(s)"
      installFile "$fileDst" "$2"
    fi
    echo "Writing $1 to db"
    fileDB["$fileDst"]+="$2"
  }


  # arg1: font destination
  # arg2: font source
  installFont() {
    sym "$1" "$2"
    echo "Updating font cache"
    fc-cache
  }

  # arg1: font location
  removeFont(){
    shopt -s nocaseglob
    rm $1*
    fc-cache
  }
  # arg1: fontName
  # arg2: fontSrc
  font() {
    local fontDst="$HOME/.local/share/fonts"
    if [[ ''${serializedFontDB["$fontDst/$1"]} ]]; then
      if [[ ''${serializedFontDB["$fontDst/$1"]} == "$2" ]]; then
        echo "Skipping font $1, has not changed"
      else
        echo "Updating font(s)"
        installFont "$fontDst" "$2"
      fi
    else
      echo "Installing new font(s)"
      installFont "$fontDst" "$2"
    fi
    echo "Writing $1 to db"
    fontDB["$fontDst/$1"]+="$2"
  }

  # arg1: service name
  # arg2: service destination
  # arg3: service source
  installService(){
    sym "$2" "$3"
    systemctl --user daemon-reload
    echo "Enabling service $1"
    systemctl --user enable "$1"
  }

  # arg1: service location
  removeService(){
    serviceName="$(basename $1)" 
    echo "Stopping service $serviceName"
    systemctl --user stop "$serviceName"
    echo "Disabling service $serviceName"
    systemctl --user disable "$serviceName"
    systemctl --user daemon-reload
  }

  # arg1: serviceName
  # arg2: serviceSrc
  service () {
    local serviceDst="$HOME/.config/systemd/user/$1"
    if [[ ''${serializedServiceDB["$serviceDst"]} ]]; then
      if [[ ''${serializedServiceDB["$serviceDst"]} == "$2" ]]; then
        echo "Skipping service $1, has not changed"
      else
        echo "Updating service(s)"
        installService $1 "$serviceDst" "$2"
        fi
    else
      echo "Installing new service(s)"
      installService $1 "$serviceDst" "$2"
    fi
    echo "Writing $1 to db"
    serviceDB["$serviceDst"]+="$2"
  }

  cleanupFiles
  cleanupFonts
  cleanupServices
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
