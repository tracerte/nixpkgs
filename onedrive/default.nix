{ nixpkgs ? import <nixpkgs> {}}:
let
  service = import ./service.nix {};
in
with nixpkgs;
{
  env = buildEnv {
    name = "onedriveEnv";
    paths = [
      onedrive
      gocryptfs
    ];
  };
  services = {"onedrive.service" = "${service}/lib/systemd/user/onedrive.service";};
  files = {};
  fonts = {};
}
