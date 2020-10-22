{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;

let
  extensions = [ mopidy-mpd mopidy-iris ];
in
buildEnv {
    name = "mopidy-with-extensions-${mopidy.version}";
    paths = [ mopidy ] ++ extensions;
    pathsToLink = [ "/${mopidyPackages.python.sitePackages}" ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      makeWrapper ${mopidy}/bin/mopidy $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${mopidyPackages.python.sitePackages}
    '';
  }
