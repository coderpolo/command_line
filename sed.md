# 打印指定行
sed -n '1p' fileName
# 打印不连续行
sed -n '1p;3p' fileName
# 打印连续行
sed -n '1,3p' fileName

# 原地删除指定行
sed -i '1d' fileName
# 原地删除不连续行
sed -i '1d;3d' fileName
# 删除连续行
sed -i '1,3d' fileName

# 对于比较重要的文件 删除最好用重定向，以原地删除为例
sed '1d' fileName >tmpfile && mv tmpfile fileName

# sed从匹配行删除到最后一行
sed -i '/^abc/,$d' fileName

# sed删除匹配的行
sed -i '/abc/d' filename

# sed替换指定行内的字符 -- 可结合xargs
sed -i '262,265s/x/y/' filename

# sed使用竖线分隔符替换行内字符
sed -i '262,255s|x|y' filename

# sed替换匹配行的全部内容
sed  "/old content/c\new content/" filename
sed "s/old content/new content/" filename
