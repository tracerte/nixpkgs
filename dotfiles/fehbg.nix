pkgs:
let
  wallpaperDir = ./wallpapers;
in
pkgs.writeScriptBin "fehbg" ''
  #! /usr/bin/env bash
  ${pkgs.feh}/bin/feh --bg-max --no-fehbg --randomize ${wallpaperDir}/* 
''
