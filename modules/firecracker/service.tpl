[Unit]
Description=Firecracker VM - ${description}
After=network.target
StartLimitIntervalSec=0
AssertPathExists=/opt/firecracker/vm/${id}/config.json

[Service]
Type=simple
Restart=no
RestartSec=1
User=firecracker
WorkingDirectory=/opt/firecracker/vm/${id}
ExecStart=firecracker --no-api --config-file config.json

[Install]
WantedBy=multi-user.target