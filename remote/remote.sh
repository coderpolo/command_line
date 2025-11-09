#!/bin/bash
# check_process_mem.sh
# 计算本机指定进程实际占用内存（RSS），单位 GB
# 参数：进程名（可选，默认 procName）

PROC_NAME=${1:-procName}   # 如果没传参数，默认 procName

hostname=$(hostname)

# 遍历所有匹配进程
ps -eo comm,rss,args | grep "[${PROC_NAME:0:1}]${PROC_NAME:1}" | while read comm rss args; do
    # RSS KB -> GB
    mem_gb=$(awk -v r=$rss 'BEGIN{printf "%.2f", r/1024/1024}')
    echo "$hostname $comm ${mem_gb}G"
done