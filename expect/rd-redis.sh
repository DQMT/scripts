#!/usr/bin/expect


set fortress_ip xxx
set fortress_port xxx
set fortress_username xxx
set fortress_password xxx
set k8s_master_ip xxx
set k8s_master_port xxx
set k8s_master_username xxx
set k8s_master_password xxx
set rd_redis_ip xxx
set rd_redis_port xxx
set rd_redis_username xxx
set rd_redis_password xxx

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
       send "ssh -p $k8s_master_port $k8s_master_username@$k8s_master_ip\r"
}
expect {
        "(yes/no)" {
          send "yes\r"; exp_continue
        }
        "*assword:" {
          send "$k8s_master_password\r"
        }
}
expect "$k8s_master_username" {
       send "ssh -p $rd_redis_port $rd_redis_username@$rd_redis_ip\r"
}
expect {
        "(yes/no)" {
	  send "yes\r"; exp_continue
       }
        "*assword:" {
       send "$rd_redis_password\r"
       }
}
expect "$rd_redis_username" {
       send "redis-cli -c \r"
}

interact

