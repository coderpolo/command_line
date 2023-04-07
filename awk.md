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