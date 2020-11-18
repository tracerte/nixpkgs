{ }:
let
  nixpkgs = import <nixpkgs> {};
  emacsBin = nixpkgs.emacs;
  emacsWithPackages = (nixpkgs.emacsPackagesGen emacsBin).emacsWithPackages;
in
with nixpkgs;
{
  env = buildEnv {
    name = "emacsEnv";
    paths = [
      (emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
      ripgrep
      coreutils
      fd
      aspell
      aspellDicts.en
      pandoc
      nixfmt
      shellcheck
      multimarkdown
    ];
  };
  files = {};
  services = {};
  fonts = {
    "all-the-icons" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/all-the-icons.ttf";
    "file-icons" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/file-icons.ttf";
    "fontawesome" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/fontawesome.ttf";
    "material-design-icons" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/material-design-icons.ttf";
    "octicons" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/octicons.ttf";
    "weathericons" = "${emacs-all-the-icons-fonts}/share/fonts/all-the-icons/weathericons.ttf"; 
  };
}
