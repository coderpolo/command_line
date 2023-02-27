# 批量转换图片格式从jpeg到jpg（使用imagemagick）
find . -name "*.jpeg" | xargs -n 1 bash -c 'convert "$0" "${0%.jpeg}.jpg"'
# find在当前目录下搜索（排除子文件夹）
find . -path ./misc -prune -o -name '*.txt' -print

# 删除带空格的文件名 -- 哈哈 -I选项会对参数中的空格做转义 --刚需！
find . -name "* *" | xargs -I name rm -rf name
#搜索指定后缀文件名，并按大小排序输出
find . -name "*.conf" -size +1k | xargs -0 du -h | sort -nr

# 搜索指定大小的文件 如查找大于100M且小于500M的文件 --建议使用find前先用tldr看下
find ./ -size -500M -size +100M

# 搜索10天前更改过的文件夹
find .  -type d -mtime +10
# 搜索10天前更改过的文件
find .  -type f -mtime +10

# 搜索指定时间段内修改过的文件
find ./ -newermt "2017-11-06 17:30:00" ! -newermt "2022-11-06 22:00:00" -name "*.txt"

