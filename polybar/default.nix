{}:
let
  nixpkgs = import <nixpkgs> { overlays = [ (import ./overlay.nix) ];};
in 
with nixpkgs;
{
  env = buildEnv {
    name = "polybarEnv";
    paths = [
      polybar
    ];
  };
  files = {
    ".config/polybar/config" = ./config;
    ".config/polybar/launch.sh" = import ./launch.nix { inherit nixpkgs; };
  };
  services = {};
  fonts = {
    "siji" = "${siji}/share/fonts/misc";
  };
}
