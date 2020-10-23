{}:
with import <nixpkgs> {};
writeTextDir "lib/systemd/user/mpd.service" ''
[Unit]
Description=Music Player Daemon
Documentation=man:mpd(1) man:mpd.conf(5)
After=network.target sound.target

[Service]
Type=notify
Description=Music Player Daemon

[Service]
ExecStart=${mpd}/bin/mpd --no-daemon

[Install]
WantedBy=default.target
''
