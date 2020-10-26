{}:
let
  nixpkgs = import <nixpkgs> {}; 
in
with nixpkgs;
{
  env = buildEnv {
    name = "zshEnv";
    paths = with pkgs; 
    [
      zsh
      zsh-syntax-highlighting
      zsh-autosuggestions
      zsh-powerlevel10k
      lf
    ];
  };
  files = {
    ".zshrc" = import ./zshrc.nix nixpkgs;
    ".zshenv" = ./zshenv;
  };
  services = {};
  fonts = {
    "MesloLGS" = ./mesloLGSNF;
  };
}
