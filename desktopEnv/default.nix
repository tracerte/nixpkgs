{ pkgs, monitorAssignment ? "" }:
let
  dotfiles = {
        ".Xresources" = ./Xresources;
        ".xsession" = import ./xsession.nix { inherit pkgs monitorAssignment; };
        ".config/dunst/dunstrc" = ./dunstrc;
      };
  symlinkHome = import ../symHome/default.nix {pkgs = pkgs; files = dotfiles;};
in
pkgs.buildEnv {
  name = "desktopEnv";
  paths = with pkgs; 
  [
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
  # postBuild = "${symlinkHome}/bin/symHome";
}
