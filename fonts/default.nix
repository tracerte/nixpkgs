pkgs:
let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
  fonts = {
    "sourceCodePro" = "${pkgs.source-code-pro}/share/fonts/opentype";
    "siji" = "${pkgs.siji}/share/fonts/misc";
    "mesloLGSNF" = ./mesloLGSNF;
    "shareTechMonoNF" = ./shareTechMonoNF;
  };
in
pkgs.writeScriptBin "updateFonts" (''
  #! /usr/bin/env bash
  set -e
  install_fonts() {
    local dst="$HOME/.local/share/fonts" 
    mkdir -p "$dst"
    local dir=$2
    echo "Symlinking font $1"
    for file in "$dir"/*
    do
      ln -sf "$dir"/"$(basename "$file")" "$dst"/"$(basename "$file")"
    done
    echo "Updating font cache"
    fc-cache
  }
''
+ lib.concatStringsSep "\n" (
  lib.mapAttrsToList
    (name: value: "install_fonts \"${name}\" \"${value}\"")
    fonts
)
)
