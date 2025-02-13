#!/bin/bash

# 获取当前是星期几 (1-7, 1 代表周一)
current_day=$(date +%u)

# 设置唤醒时间
wake_hour="8:30"

# 根据星期几，设置正确的唤醒时间
case $current_day in
  5|6|7)
    # 如果是周五、周六或周日，计算下周一的 8:30
    wake_time=$(date +%s -d "next monday $wake_hour")
    ;;
  *)
    # 否则，计算明天的 8:30
    wake_time=$(date +%s -d "tomorrow $wake_hour")
    ;;
esac

# 设置 RTC 唤醒时间 (不休眠)
rtcwake -m no -t "$wake_time"