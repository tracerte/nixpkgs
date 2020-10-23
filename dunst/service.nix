{}:
with import <nixpkgs> {};

writeTextDir "lib/systemd/user/dunst.service" ''
[Unit]
Description=Dunst notification daemon
Documentation=man:dunst(1)
After=dbus.socket
PartOf=graphical-session.target

[Service]
Type=dbus
BusName=org.freedesktop.Notifications
ExecStart=${dunst}/bin/dunst

[Install]
WantedBy=default.target
''
