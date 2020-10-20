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
  ${monitorScript}/bin/monitorAssignment &
  ${fehScript}/bin/fehbg &
  ${dunst}/bin/dunst &
  exec ${i3}/bin/i3
''
