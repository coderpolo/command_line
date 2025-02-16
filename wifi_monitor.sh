#!/bin/bash

# 定义要检测的关键词
WIFI_KEYWORD="Lobby"

# 定义要执行的命令
COMMAND="rm -rf /tmp/ssh-wukaisheng@mc4.adsys.shbt.qihoo.net ; cd ~/Download/qihoo-vpn-utils && ./qihoo-vpn qc-smart && cd -"

# 定义一个变量，用于记录上一次的 WiFi 名称
LAST_WIFI_NAME=""

# 定义日志文件路径
LOG_FILE="/tmp/wifi_monitor.log"

# 定义一个函数，用于将日志消息写入文件
log() {
  timestamp=$(date +'%Y-%m-%d %H:%M:%S')
  echo "$timestamp: $1" >> "$LOG_FILE"
  echo "$timestamp: $1" # 同时输出到屏幕
}

# 循环检测 WiFi 名称
while true; do
  # 只检查 wlp0s20f3 网卡的 WiFi 连接名称
  WIFI_NAME=$(nmcli -t -f NAME,DEVICE connection show --active | grep "wlp0s20f3" | cut -d: -f1)

  # 检查 WiFi 名称是否为空
  if [ -z "$WIFI_NAME" ]; then
      WIFI_NAME="No Connection" # 没有连接时，设置一个默认值
  fi

  # 检查 WiFi 名称是否发生变化
  if [[ "$WIFI_NAME" != "$LAST_WIFI_NAME" ]]; then
    # WiFi 名称发生了变化
    log "WiFi 名称已更改：从 '$LAST_WIFI_NAME' 变为 '$WIFI_NAME'"

    # 检测新的 WiFi 名称是否包含关键词
    if [[ "$WIFI_NAME" == *"$WIFI_KEYWORD"* ]]; then
      log "新的 WiFi '$WIFI_NAME' 包含 '$WIFI_KEYWORD'. 执行命令..."
      eval "$COMMAND"
      log "命令执行完毕"
    else
      log "新的 WiFi '$WIFI_NAME' 不包含 '$WIFI_KEYWORD'，不执行命令。"
    fi

    # 更新上一次的 WiFi 名称
    LAST_WIFI_NAME="$WIFI_NAME"
  else
    # WiFi 名称没有发生变化
    log "WiFi 名称未更改，仍然是 '$WIFI_NAME'."
  fi

  # 暂停一段时间 (5 秒)
  sleep 5

done
