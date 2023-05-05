# grep从多个条件搜索
grep -E 'conditionA|conditionB'  -irn ./ 
# grep从日志匹配一个key的多value
grep -E 'key=(conditionA|conditionB)'  -irn ./

# grep排除多个文件
grep -E 'conditionA|conditionB'  -irn ./ --exclude='y' --exclude='fileNamePrefix*' --exclude='*FilenamePostfix' --exclude-dir='subDir' 

# grep匹配三位数字
grep '\<[0-9][0-9][0-9]\>' a.txt

# grep匹配100-199数字
grep '\<1[0-9][0-9]\>' a.txt

# 对access日志先条件过滤，再取出指定参数的value -- 后续可以用 q 来统计分布。
cat access.log | grep "x=&" | grep -o "y=\<[0-9][0-9]\>"

# 过滤空行
grep "^$" fileName

# 使用xargs多进程grep日志
find . -name "*filename*" | xargs -P20 grep sth