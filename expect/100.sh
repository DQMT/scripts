#!/usr/bin/expect


set 100_ip xxx
set 100_port xxx
set 100_username xxx
set 100_password xxx

#子程序窗口随父程序窗口一起改变大小
trap {
set rows [stty rows]
set cols [stty columns]
stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

spawn ssh -p $100_port $100_username@$100_ip
expect {
        "(yes/no)" {
	  send "yes\r"; exp_continue
        }
        "*assword:" {
	  send "$100_password\r"
        }
}

interact

