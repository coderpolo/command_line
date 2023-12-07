process_bucket() {
    bucket_name="$1"
    echo $bucket_name;
}

# 导出函数，以便xargs调用
export -f process_bucket

# 逐行读取S3桶名，并使用xargs控制并发进程数
cat "$bucket_list_file" | xargs -P "$concurrency" -I{} bash -c 'process_bucket "$@"' _ {}

# 从远端拷贝文件到中心机器
pslurp -h ../hostfile "remot_file_name" local_path