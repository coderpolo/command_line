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
cat keys | xargs -I {} redis-cli get {}

#从文件中删除指定字符，如括号  --总的来说，tr比sed简单一些。我主要用来替换大日志中的字符。一般代码中的变量替换，使用IDEA就可以了。
cat fileName | tr -d "()"

#将文件中的指定字符做替换 ,如 '\t' 替换成 ','
cat fileName | tr "\t" ","

#批量转换图片格式从jpeg到jpg（使用imagemagick）
find . -name  "*.jpeg" | xargs -n 1 bash -c 'convert "$0" "${0%.jpeg}.jpg"'

#find在当前目录下搜索（排除子文件夹）
find . -path ./misc -prune -o -name '*.txt' -print