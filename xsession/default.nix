{ monitorAssignment ? "" }:
let 
  nixpkgs = import <nixpkgs> { };
  lpkgs = import ../all-packages.nix;
  polybar = import lpkgs.polybar {};
  feh = import lpkgs.feh {};
  fehScript = import feh.script {};
  dunst = import lpkgs.dunst {};
in
with nixpkgs;
{ 
  env = buildEnv {
    name = "xsessionEnv";
    paths = [
      dmenu
      picom
      xorg.xev
      xorg.xbacklight
      libnotify
      polybar.env
      feh.env
      dunst.env
    ];
  };
  services = polybar.services // feh.services // dunst.services;
  files = polybar.files // feh.files // dunst.files // {
    ".xsession" = import ./xsession.nix { inherit nixpkgs fehScript monitorAssignment; };
  };
  fonts = polybar.fonts // feh.fonts // dunst.fonts;

}
