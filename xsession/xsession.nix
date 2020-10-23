{ nixpkgs ? import <nixpkgs> {},fehScript ? "", monitorAssignment ? "" }:
with nixpkgs;
let
  monitorScript = writeScriptBin "monitorAssignment" ''
    #! /usr/bin/env bash
    ${monitorAssignment}
      '';
in
writeScript "xsession" ''
  #! /usr/bin/env bash
  ${picom}/bin/picom &
  ${monitorScript}/bin/monitorAssignment &
  ${fehScript}/bin/fehbg &
  exec ${i3}/bin/i3
''
