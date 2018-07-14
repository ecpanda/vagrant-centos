# 安装supervisor - 用于监控队列
if [ ! -e "/usr/bin/supervisord" ]; then
    sudo yum install -y supervisor

    sudo rm -f /usr/lib/systemd/system/supervisord.service

    echo ">>> Supervisor安装完成"
fi

if [ ! -e "/usr/lib/systemd/system/supervisord.service" ]; then
SUPERVISORD_SYSTEMD_SERVICE="
#supervisord service for systemd (CentOS 7.0+)
[Unit]
Description=Supervisor daemon

[Service]
Type=forking
ExecStart=/usr/bin/supervisord
ExecStop=/usr/bin/supervisorctl \$OPTIONS shutdown
ExecReload=/usr/bin/supervisorctl \$OPTIONS reload
KillMode=process
Restart=on-failure
RestartSec=42sc

[Install]
WantedBy=multi-user.target
"

echo "$SUPERVISORD_SYSTEMD_SERVICE" | sudo tee -a /usr/lib/systemd/system/supervisord.service

sudo systemctl enable supervisord
sudo systemctl restart supervisord

echo ">>> Supervisord 服务激活并重启完成"
fi