#!/usr/bin/expect


set fortress_ip xxx
set fortress_port xxx
set fortress_username xxx
set fortress_password xxx
set rd_mycli_ip xxx
set rd_mycli_port xxx
set rd_mycli_username xxx
set rd_mycli_password xxx
set rd_mysql_host xxx
set rd_mysql_username xxx
set rd_mysql_password xxx
set rd_mysql_database xxx
#子程序窗口随父程序窗口一起改变大小
trap {
set rows [stty rows]
set cols [stty columns]
stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

spawn ssh -p $fortress_port $fortress_username@$fortress_ip
expect {
        "(yes/no)" {
	  send "yes\r"; exp_continue
        }
        "*assword:" {
	  send "$fortress_password\r"
        }
}
expect "$fortress_username" {
       send "ssh -p $rd_mycli_port $rd_mycli_username@$rd_mycli_ip\r"
}
expect {
        "(yes/no)" {
          send "yes\r"; exp_continue
        }
        "*assword:" {
          send "$rd_mycli_password\r"
        }
}
expect "$rd_mycli_username" {
       send "mycli -h $rd_mysql_host -u $rd_mysql_username -p$rd_mysql_password $rd_mysql_database\r"
}
interact

