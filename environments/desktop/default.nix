{ monitorAssignment ? "" }:
let 
  nixpkgs = import <nixpkgs> { overlays = [ (import ./polybar/overlay.nix) ];};
in
with nixpkgs;
{ 
  env = buildEnv {
    name = "desktopEnv";
    paths = [
      i3
      i3lock
      alacritty
      polybar
      dmenu
      picom
      xorg.xev
      xorg.xbacklight
      neovim-qt
      feh
      dunst
      libnotify
      pcmanfm
      firefox
      chromium
      libreoffice-fresh
      hunspell
      hunspellDicts.en-us
    ];
  };
  files = {
    ".config/i3/config" = ./i3/config;
    ".alacritty.yml" = import ./alacritty { inherit nixpkgs; };
    ".xsession" = import ./xsession.nix { inherit nixpkgs monitorAssignment; };
    ".config/dunst/dunstrc" = ./dunst/dunstrc;
    ".config/polybar/config" = ./polybar/config;
    ".config/polybar/launch.sh" = import ./polybar/launch.nix { inherit nixpkgs; };
  };
}
