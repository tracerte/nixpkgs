pkgs :

let
  lib = pkgs.lib;
  home = builtins.getEnv "HOME";
  fonts = {
    "sourceCodePro" = ./sourceCodePro;
    "mesloLGSNF" = ./mesloLGSNF;
    "shareTechMonoNF" = ./shareTechMonoNF;
  };
in
  pkgs.writeScriptBin "installFonts" (''
    #! /usr/bin/env/ bash
    install_fonts() {
      local dst="$HOME/.local/share/fonts" 
      if [ ! -d "$dst" ]
      then
        mkdir -p "$dst"
      fi
      echo "Copying $1 to local fonts directory"
      cp -R "$2/." "$dst/"
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
