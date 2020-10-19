pkgs:
let
  dotfiles = {
    ".zshrc" = import ./zshrc.nix pkgs;
    ".zshenv" = ./zshenv;
    ".p10k.zsh" = ./p10k.zsh;
  };
  symlinkHome = import ../symHome/default.nix {pkgs = pkgs; files = dotfiles;};
in
pkgs.buildEnv {
  name = "terminalEnv";
  paths = with pkgs; 
  [
    lf
    tmux
    zip
    unzip
  ];
  # postBuild = "${symlinkHome}/bin/symHome";
}
