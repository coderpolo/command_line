#!/bin/bash
# 脚本：power-mode-switch.sh
# 描述：检测电源状态并切换电源模式。

# 定义电源模式
power_saver_mode="power-saver"  # 省电模式
performance_mode="performance"  # 性能模式

# 获取当前电源状态
get_power_state() {
  ac_online=$(cat /sys/class/power_supply/AC/online)
  echo "$ac_online"
}

# 切换电源模式
set_power_mode() {
  mode="$1"
  echo "切换到 $mode 模式"
  powerprofilesctl set "$mode"

  # （可选）记录日志
  echo "$(date +'%Y-%m-%d %H:%M:%S')：切换到 $mode 模式" >> /tmp/power-mode-switch.log
}

# 主逻辑
main() {
  power_state=$(get_power_state)

  if [[ "$power_state" -eq 1 ]]; then
    # 插上电源
    set_power_mode "$performance_mode"
  else
    # 拔出电源
    set_power_mode "$power_saver_mode"
  fi
}

# 运行主逻辑
main