{ nixpkgs ? import <nixpkgs> { overlays = [ (import ./neovim.nix)];}}:
with nixpkgs;
{
  env = buildEnv {
    name = "neovimEnv";
    paths = [
      neovim
      nodejs
    ];
  };
  files = {};
}

