{ }:

let
  nixpkgs = import <nixpkgs> {};
in
with nixpkgs;
{
  env = buildEnv {
    name = "git-env";
    paths = [
      gitAndTools.gitFull
    ];
  };
  files = {
    ".gitconfig" = ./gitconfig;
  };
  services = {};
  fonts = {};
}



