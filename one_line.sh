#背景：因为跳板机的存在，本机没法直接从远程机器（服务器）拷贝日志。
#所以换一个思路，在本机装一个sshd server。把远程机器当做client来使用。

#在远程机器往本机拷文件
scp -v sth user@your_computer_ip:/home/w/Downloads
#在远程机器上将本机的文件拷过去
scp -v user@your_computer_ip:/home/w/Downloads/sth ~/

#批量停止docker容器。
sudo docker ps | awk '{print $1}' | xargs sudo docker stop

#根据进程名kill
ps -aef | grep "wps" | awk '{print $2}' | xargs kill -9

#复制ip地址到剪贴板 -- 具体取决于有多少张网卡和前缀
ifconfig | grep "inet" | grep 10 | grep -v "inet6" | awk '{print $2}' | cb

#复制最后一个commit到剪贴板 -- 提到的cb是本项目中名为cb的脚本。
git log -1 | awk '{print $2}' | head -n1 | cb

#复制git repo地址到剪贴板
git remote -v | awk '{print $2}' | sed -n 1p | cb

#复制当前git分支到剪贴板
git branch --show-current | cb

#从剪贴板读取上一个commit，并cherry-pick。嘿嘿
cb | xargs git cherry-pick

#从剪贴板grep。惊人好用。
cb | grep "abc"

#复制外网IP地址到剪贴板
curl ifconfig.me | cb

#利用fzf的模糊搜索，交互式切换分支
git checkout $(gb | fzf)

# git与remote master做diff
git diff origin/master --no-prefix -U1000 --ignore-space-change >~/1.diff

#统计git提交代码行数
git log --format='%aN' | sort -u | while read name; do
  echo -en "$name\t"
  git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
done

#用sql直接查询文本文件。http://harelba.github.io/q/
q -d $',' "select c1,max(c3) from ./txt_file group by c1"

# 使用 q 去查询两个文件 -- 超级实用
q "select tableA.c1 ,tableB.c2 from fileA tableA join fileB tableB on (tableA.c1 = tableB.c1)"

#使用 q 查询文本文件，并在每行拼接上引号和逗号,粘贴到剪贴板
q -d $',' "select *  from  fileA where c2 in (select c2 from fileA  group by c2 having count(c2)>2 ) and c5 like '%xyz%'
order by c5" | awk -F "," '{print $3}' | xargs printf '"%s",\n' | cb | tee

#后台运行脚本。使用source不需要可执行权限。
source scricpt.sh >scricpt.log 2>&1 &

#从一堆host中取出ip
cat host_record | xargs dig | grep "A" | rg -e "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk '{print $5}' | sort

#从一堆ip中取出host
cat ip_record | nslookup | grep "name = " | column -t

# | xargs占位符妙用 -- 以前都是在列模式下批量编辑命令...
cat keys | xargs -I key redis-cli get key

#从文件中删除指定字符，如括号  --总的来说，tr比sed简单一些。我主要用来替换大日志中的字符。一般代码中的变量替换，使用IDEA就可以了。
cat fileName | tr -d "()"

#将文件中的指定字符做替换 ,如 '\t' 替换成 ','
cat fileName | tr "\t" ","

#批量转换图片格式从jpeg到jpg（使用imagemagick）
find . -name  "*.jpeg" | xargs -n 1 bash -c 'convert "$0" "${0%.jpeg}.jpg"'

#find在当前目录下搜索（排除子文件夹）
find . -path ./misc -prune -o -name '*.txt' -print

#查看文件夹占用空间 -- 服务器上一般没有ncdu
du -lh --max-depth=1

#对access日志先条件过滤，再取出指定参数的value -- 后续可以用 q 来统计分布。
cat access.log | grep "x=&"  | grep -o "y=\<[0-9][0-9]\>"

#后台运行进程，将stdout和stderr重定向到文件
zsh sth.sh  >out.file 2>&1 &

# 在本机使用xargs 对每个key批量执行多条命令（下面将echo执行了两次）
cat keys | xargs -I key sh -c 'echo key && echo key'
cat keys | xargs -I key sh -c 'echo key ; echo key'

# 批量在远程主机上执行多条命令 （第一条命令 ifconfig 第二条命令 hostname）
cat hosts | xargs -I machine  ssh -T -o StrictHostKeyChecking=no   machine  "/usr/sbin/ifconfig && hostname"

# 删除带空格的文件名 -- 哈哈 -I选项会对参数中的空格做转义 --刚需！
find . -name "* *" | xargs  -I name rm -rf name

# python 启动一个http服务器
python -m SimpleHTTPServer 8080
python3 -m http.server 8080

#搜索指定后缀文件名，并按大小排序输出
find . -name "*.conf" -size +1k | xargs -0 du -h | sort -nr

#搜索指定大小的文件 如查找大于100M且小于500M的文件 --建议使用find前先用tldr看下
find ./ -size -500M -size +100M

#查看进程的启动时间
ps -eo pid,lstart,etime,cmd | grep nginx | grep -v "grep"

#开机启动项管理
systemctl list-unit-files --type=service|grep enabled
sudo systemctl disable apache2.service

#ls按时间排序
ls -lrt
ls -lr

#ls按大小排序
ls lSh
ls -lShr

#时间戳转日期。登服务器的时候用的比较多，不用再粘贴到网页了
date -d@1648387801