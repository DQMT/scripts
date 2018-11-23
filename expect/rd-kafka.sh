#!/usr/bin/expect


set fortress_ip xxx
set fortress_port xxx
set fortress_username xxx
set fortress_password xxx
set rd_kafka_ip xxx
set rd_kafka_port xxx
set rd_kafka_username xxx
set rd_kafka_password xxx
set rd_kafka_path xxx
set rd_kafka_zookeeper_connect xxx
set rd_kafka_bootstrap_server xxx
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
       send "ssh -p $rd_kafka_port $rd_kafka_username@$rd_kafka_ip\r"
}
expect {
        "#" {
         send ""
        }
        "(yes/no)" {
          send "yes\r"; exp_continue
        }
        "*assword:" {
          send "$rd_kafka_password\r"
        }
}
expect "$rd_kafka_username" {
          send "cd $rd_kafka_path\r"
}
expect "$rd_kafka_path" {
          send_tty "Example:\n\
		  ./kafka-console-consumer.sh --bootstrap-server $rd_kafka_bootstrap_server --topic ddcsavedata --from-beginning \n\
		  ./kafka-topics.sh --zookeeper $rd_kafka_zookeeper_connect --list \r\r"
}
expect "" {
      send "\r"
}
interact

