{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;
{
  env = buildEnv {
    name = "fehEnv";
    paths = [
      i3
      i3lock
    ];
  };
  services = {};
  files = {".config/i3/config" = ./config;};
  fonts = {};
}
