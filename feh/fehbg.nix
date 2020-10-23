{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;
let
  wallpaperDir = ./wallpapers;
in
writeScriptBin "fehbg" ''
  #! /usr/bin/env bash
  ${feh}/bin/feh --bg-max --no-fehbg --randomize ${wallpaperDir}/* 
''
