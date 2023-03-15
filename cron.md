# 使用命令添加定时任务-可将这条命令以脚本的方式拷贝到各个主机。然后用xargs触发各个主机使用此脚本
(echo "*/1 0-10 * * * (rm -rf /tmp)"; crontab -l)|crontab

# 批量清空各个机器的定时任务
cat hostFile |  xargs -I machine ssh -T -o StrictHostKeyChecking=no machine "hostname && crontab -r "

# cron将标准输出重定向到日志文件
*/1 * * * * /root/XXXX.sh > /tmp/run.log 2>&1 &

# flock控制crontab脚本单例执行
* * * * * root (flock -xn /tmp/bsline.lock -c 'ls /tmp')

# 查看cron日志
tail -n 100 /var/log/cron


