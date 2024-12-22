#!/usr/bin/expect -f

#用于登录时自动切换到公用账户，cd到公用账户的私人子目录。这个脚本放在私人账户的.在bashrc里面alias下 比如重命名为a。
#在私人账户登录后，输入a就自动切换到公用账户。并cd到公用账户的自己私人目录
set password "123456"

spawn sudo -H -u commUserName bash

expect "password"
send "$password\r"
expect "$ "
send "cd /home/commUserName/yourName\r"
send "clear\r"

interact