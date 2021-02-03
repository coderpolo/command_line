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

#复制最后一个commit到剪贴板
git log -1 | awk '{print $2}' | head -n1 | cb

#从剪贴板读取上一个commit，并cherry-pick。嘿嘿
cb | xargs git cherry-pick

#复制git repo地址到剪贴板
git remote -v | awk '{print $2}' | sed -n 1p | cb

#利用fzf的模糊搜索，交互式切换分支
git checkout $(gb | fzf)

#用sql直接查询文本文件。http://harelba.github.io/q/
q -d $',' "select c1,max(c3) from ./txt_file group by c1"

#后台运行脚本。使用source不需要可执行权限。
source scricpt.sh >scricpt.log 2>&1 &
