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

#从剪贴板读取上一个commit，并cherry-pick。嘿嘿
cb | xargs git cherry-pick

#从剪贴板grep。惊人好用。
cb | grep "abc"

#复制最后一个commit到剪贴板
git log -1 | awk '{print $2}' | head -n1 | cb

#复制git repo地址到剪贴板
git remote -v | awk '{print $2}' | sed -n 1p | cb

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

#后台运行脚本。使用source不需要可执行权限。
source scricpt.sh >scricpt.log 2>&1 &

#从一堆host中取出ip
cat host_record | xargs dig | grep "A" | rg -e "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk '{print $5}' | sort

#从一堆ip中取出host
cat ip_record | nslookup | grep "name = " | column -t

# | xargs占位符妙用 -- 以前都是在列模式下批量编辑命令...
cat keys | xargs -I {} redis-cli get {}
