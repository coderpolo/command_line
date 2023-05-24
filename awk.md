# 求和
cat data|awk '{sum+=$1} END {print "Sum = ", sum}'

# 平均值
cat data|awk '{sum+=$1} END {print "Average = ", sum/NR}'

# 最大值
cat data|awk 'BEGIN {max = 0} {if ($1>max) max=$1 fi} END {print "Max=", max}'

# 最小值
awk 'BEGIN {min = 2147483648} {if ($1<min) min=$1 fi} END {print "Min=", min}'

# 去重（性能较快）
awk '!x[$0]++' 

# awk打印倒数第二列，倒数第一列
awk '{print $(NF-1), $NF}' filename.txt

# awk根据^A切割
awk -F "\x01" '{print $1}' filename

# awk指定多个分隔符 ,#
cat fileName | awk -F "[,#]" '{print $1,$2}'

# awk指定一个分割符(单词或字符)
cat fileName | awk -F "word" '{print $1,$2}'
cat fileName | awk -F " " '{print $1,$2}'

# awk按条件打印
awk '$3 == 1 {print}' filename

# awk 从某一列中截取substr打印 (从第列的第十二个字符开始截取第一个字符)
 awk '{if(substr($3, 12, 1) != 1) print}' filename
 
# awk 查询字符串位于哪一列
awk '{for(i=1;i<=NF;i++)if(index($i,"foo"))print i}' filename

#从按|分割的日志文件中提取的指定字段
awk -F'|' '{ split($0, arr, "field="); split(arr[2], fieldArr, "|"); printf "%s\n", fieldArr[1] }' logfile.log
