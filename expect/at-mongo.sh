#!/usr/bin/expect


set fortress_ip xxx
set fortress_port xxx
set fortress_username xxx
set fortress_password xxx
set at_mongo_ip xxx
set at_mongo_port xxx
set at_mongo_username xxx
set at_mongo_password xxx
set mongo_admin_db xxx
set mongo_admin_username xxx
set mongo_admin_password xxx

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
       send "ssh -p $at_mongo_port $at_mongo_username@$at_mongo_ip\r"
}
expect {
        "(yes/no)" {
          send "yes\r"; exp_continue
        }
        "*assword:" {
          send "$at_mongo_password\r"
        }
}
expect "$at_mongo_username" {
       send "mongo\r"
}
expect "mongo" {
       send "use $mongo_admin_db\r"
}
expect "switched to " {
       send "db.auth(\"$mongo_admin_username\",\"$mongo_admin_password\")\r"
}
interact

