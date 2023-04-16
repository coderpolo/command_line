# 复制ip地址到剪贴板 -- 具体取决于有多少张网卡和前缀
ifconfig | grep "inet" | grep 10 | grep -v "inet6" | awk '{print $2}' | cb

# 从剪贴板grep。惊人好用。
cb | grep "abc"

# 复制外网IP地址到剪贴板
curl ifconfig.me | cb

# 命令行查ip地址
curl cip.cc/172.67.161.169

# grep提取ip地址
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" filename

# ip批量查询
https://ip.tool.chinaz.com/ipbatch