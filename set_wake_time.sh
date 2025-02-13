#!/bin/bash

# 获取当前是星期几 (1-7, 1 代表周一)
current_day=$(date +%u)

# 根据当前星期几，设置明天的唤醒时间
case $current_day in
  1) wake_hour="8:30"  # 周一设置周二唤醒
     ;;
  2) wake_hour="8:30"  # 周二设置周三唤醒
     ;;
  3) wake_hour="8:30"  # 周三设置周四唤醒
     ;;
  4) wake_hour="8:30"  # 周四设置周五唤醒
     ;;
  5) wake_hour="8:30"  # 周五设置下周一唤醒
     ;;
  6) wake_hour="8:30"  # 周六什么都不做，或者可以设置周日
     ;;
  7) wake_hour="8:30"  # 周日什么都不做，或者可以设置周一（如果在周六什么都没做的话）
     ;;
  *)
    echo "Error: Invalid day of the week."
    exit 1
    ;;
esac

# 根据星期几，设置正确的唤醒时间
if [ "$current_day" -eq "5" ]; then
  # 如果是周五，计算下周一的 8:30
  wake_time=$(date +%s -d "next monday 8:30")
else
  # 否则，计算明天的 8:30
  wake_time=$(date +%s -d "tomorrow 8:30")
fi

# 设置 RTC 唤醒时间 (不休眠)
rtcwake -m no -t "$wake_time"