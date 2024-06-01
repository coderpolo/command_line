#!/bin/bash

#并发排序

# 检查输入参数
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <num_threads>"
    exit 1
fi

# 输入文件名和线程数
input_file="$1"
num_threads="$2"

# 分块前缀
chunk_prefix="chunk_"

# 分块
split -l 1000000 "$input_file" "$chunk_prefix"

# 使用 xargs 和 sort 进行并行排序
ls ${chunk_prefix}* | xargs -n 1 -P "$num_threads" -I {} sh -c 'sort {} -o {}.sorted'

# 合并已排序的块
sort -m ${chunk_prefix}*.sorted -o sorted_"$input_file"

# 清理临时文件
rm ${chunk_prefix}*