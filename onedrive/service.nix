{}:
with import <nixpkgs> {};

writeTextDir "lib/systemd/user/onedrive.service" ''
[Unit]
Description=OneDrive Free Client
Documentation=https://github.com/abraunegg/onedrive
After=network-online.target
After=graphical-session.target
Wants=network-online.target

[Service]
ExecStart=${onedrive}/bin/onedrive --monitor 
Restart=on-failure
RestartSec=3
RestartPreventExitStatus=3

[Install]
WantedBy=default.target
''
