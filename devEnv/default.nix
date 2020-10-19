pkgs:
let
  dotfiles = {
    ".gitconfig" = ./gitconfig;
    ".direnvrc" = ./direnvrc;
  };
  symlinkHome = import ../symHome/default.nix {pkgs = pkgs; files = dotfiles;};
in 
pkgs.buildEnv {
  name = "devEnv";
  paths = with pkgs; [
    direnv
    nix-direnv
    niv
    gitAndTools.gitFull
  ];
  # postBuild = "${symlinkHome}/bin/symHome";
}
