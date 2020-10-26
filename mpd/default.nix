{ nixpkgs ? import <nixpkgs> {}, music_directory ? ""}:
let 
  service = import ./service.nix {};
in
with nixpkgs;
{
  env = buildEnv {
    name = "mpdEnv";
    paths = [
      mpd
      mpc_cli
    ];
  };
  services = {
    "mpd.service" = "${service}/lib/systemd/user/mpd.service"; 
  };
  files = {
    ".config/mpd/mpd.conf" = import ./conf.nix {inherit music_directory;};
  };
  fonts = {};
}
