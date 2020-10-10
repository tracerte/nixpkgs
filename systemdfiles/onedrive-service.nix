pkgs:

pkgs.writeText "onedrive-service" ''
[Unit]
Description=OneDrive Free Client
Documentation=https://github.com/abraunegg/onedrive
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=${pkgs.onedrive}/bin/onedrive --monitor 
Restart=on-failure
RestartSec=3
RestartPreventExitStatus=3

[Install]
WantedBy=default.target
''
