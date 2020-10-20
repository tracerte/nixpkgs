{ nixpkgs ? import <nixpkgs> { overlays= [
  (import ./st.nix)
  (import ./dwm.nix)
  (import ./slstatus.nix)
];}, 
  monitorAssignment ? "" }:
with nixpkgs;
{ 
  env = buildEnv {
    name = "desktopEnv";
    paths = [
      dwm
      st
      slstatus
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
    ".Xresources" = import ./Xresources.nix { inherit nixpkgs; };
    ".xsession" = import ./xsession.nix { inherit nixpkgs monitorAssignment; };
    ".config/dunst/dunstrc" = ./dunstrc;
  };
}
