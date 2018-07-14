#!/usr/bin/env bash

# 使用supervisor监控短信Worker
if [ ! -e "/etc/supervisord.d/ms-sms-worker.conf" ]; then
SMS_WORKER_SUPERVISOR="
[program:ms-sms-worker]
process_name=%(program_name)s_%(process_num)02d
command=php ${APP_PATH}/artisan queue:work --queue=sms_code
autostart=true
autorestart=true
user=nginx
numprocs=1
redirect_stderr=true
stdout_logfile=${APP_PATH}/storage/logs/sms_worker.log
"
echo "$SMS_WORKER_SUPERVISOR" | sudo tee -a /etc/supervisord.d/ms-sms-worker.ini

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start ms-sms-worker:*

echo ">>> 发送短信worker的supervisor监控启动成功"
fi