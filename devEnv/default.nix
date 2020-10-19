{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;
{
  env = buildEnv {
    name = "devEnv";
    paths = [
      direnv
      nix-direnv
      niv
      gitAndTools.gitFull
    ];
  };
  files = {
    ".gitconfig" = ./gitconfig;
    ".direnvrc" = ./direnvrc;
  };
}
