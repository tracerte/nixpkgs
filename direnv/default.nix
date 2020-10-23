{ }:

let
  nixpkgs = import <nixpkgs> {};
in
with nixpkgs;
{
  env = buildEnv {
    name = "direnv-env";
    paths = [
      direnv
      nix-direnv
      niv
    ];
  };
  files = {
    ".direnvrc" = ./direnvrc;
  };
  services = {};
  fonts = {};
}



