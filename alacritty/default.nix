{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;
{
  env = buildEnv {
    name = "alacrittyEnv";
    paths = [
      alacritty
    ];
  };
  services = {};
  files = {".alacritty.yml" = import ./alacritty-yml.nix { };};
  fonts = {};
}
