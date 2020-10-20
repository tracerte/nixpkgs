{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;

let
  color-theme = gruvbox-dark;
  snazzy = (builtins.readFile ./xresources/themes/snazzy);
  gruvbox-dark = (builtins.readFile ./xresources/themes/gruvbox-dark);
  gruvbox-light = (builtins.readFile ./xresources/themes/gruvbox-light);
  urxvt = (builtins.readFile ./xresources/applications/urxvt);
in
  writeText "Xresources" ( urxvt + "\n" + color-theme )
