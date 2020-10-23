{ nixpkgs ? import <nixpkgs> {}}:
let
  service = import ./service.nix {};
in
with nixpkgs;
{
  env = buildEnv {
    name = "dunstEnv";
    paths = [
      dunst
    ];
  };
  services = {
    "dunst.service" = "${service}/lib/systemd/user/dunst.service"; };
  files = {
    ".config/dunst/dunstrc" = ./dunstrc;
  };
  fonts = {};
}
