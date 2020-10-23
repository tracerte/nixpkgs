{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;
{
  env = buildEnv {
    name = "fehEnv";
    paths = [
      feh
    ];
  };
  script = ./fehbg.nix;
  services = {};
  files = {};
  fonts = {};
}
