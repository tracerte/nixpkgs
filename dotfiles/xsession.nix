{ pkgs, monitorAssignment ? "" }:
let
  monitorScript = pkgs.writeScriptBin "monitorAssignment" ''
    #! /usr/bin/env bash
    ${monitorAssignment}
      '';
  fehScript = import ./fehbg.nix pkgs;
in
pkgs.writeText "xsession" ''
  ${pkgs.picom}/bin/picom &
  ${pkgs.slstatus}/bin/slstatus &
  ${monitorScript}/bin/monitorAssignment &
  ${fehScript}/bin/fehbg &
  ${pkgs.dunst}/bin/dunst &
  [[ -f ~/.Xresources ]] && ${pkgs.xorg.xrdb}/bin/xrdb -merge -I$HOME ~/.Xresources
  exec ${pkgs.dwm}/bin/dwm
''
