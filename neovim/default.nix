{ }:
let
  nixpkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix)];}; 
in
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
  services = {};
  fonts = {};
}

