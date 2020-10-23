{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;

let
  color-theme = gruvbox-dark;
  snazzy = (builtins.readFile ./themes/snazzy);
  gruvbox-dark = (builtins.readFile ./themes/gruvbox-dark);
  gruvbox-light = (builtins.readFile ./themes/gruvbox-light);
  urxvt = (builtins.readFile ./applications/urxvt);
in
  writeText "Xresources" ( urxvt + "\n" + color-theme )
