pkgs :
let
  monitorAssignment = pkgs.writeScriptBin "multiHeadX" ''
    #! /usr/bin/env bash
    nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +1920+0, DP-3.1: nvidia-auto-select +1920+0, DP-3.2: nvidia-auto-select +0+0, DP-3.3: nvidia-auto-select +3840+0"
'';
  fehScript = import ./fehbg.nix pkgs;
in
  pkgs.writeText "xinitrc" ''
  ${pkgs.picom}/bin/picom &
  ${pkgs.slstatus}/bin/slstatus &
  ${monitorAssignment}/bin/multiHeadX &
  ${fehScript}/bin/fehbg &
  exec ${pkgs.dwm}/bin/dwm
  ''
