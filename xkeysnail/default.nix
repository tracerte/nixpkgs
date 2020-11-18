{ lib
, buildPythonPackage
, evdev
, fetchPypi
, inotify-simple
, xlib
}:

buildPythonPackage rec {
  pname = "xkeysnail";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9df2499c477a21ceeea8af147a9543c06204ba49843f29a4bc3b2d0cda5a5aff";
  };

  propagatedBuildInputs = [
    evdev
    inotify-simple
    xlib
  ];

  doCheck = false;

  meta = {
    homepage = https://github.com/mooz/xkeysnail;
    description = "Yet another keyboard remapping tool for X environment";
  };
}