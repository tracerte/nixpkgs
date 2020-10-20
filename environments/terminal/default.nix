{}:
let
  nixpkgs = import <nixpkgs> {}; 
in
with nixpkgs;
{
  env = buildEnv {
    name = "terminalEnv";
    paths = with pkgs; 
    [
      lf
      tmux
      zip
      unzip
    ];
  };
  files = {
    ".zshrc" = import ./zshrc.nix nixpkgs;
    ".zshenv" = ./zshenv;
  };
}
