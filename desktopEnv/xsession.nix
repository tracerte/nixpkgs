{ nixpkgs ? import <nixpkgs> {}, monitorAssignment ? "" }:
with nixpkgs;
let
  monitorScript = writeScriptBin "monitorAssignment" ''
    #! /usr/bin/env bash
    ${monitorAssignment}
      '';
  fehScript = import ./fehbg.nix {inherit nixpkgs;};
in
writeScript "xsession" ''
  #! /usr/bin/env bash
  ${picom}/bin/picom &
  ${slstatus}/bin/slstatus &
  ${monitorScript}/bin/monitorAssignment &
  ${fehScript}/bin/fehbg &
  ${dunst}/bin/dunst &
  [[ -f ~/.Xresources ]] && ${xorg.xrdb}/bin/xrdb -merge -I$HOME ~/.Xresources
  exec ${dwm}/bin/dwm
''
