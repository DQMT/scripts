import psutil
import os,datetime,time
 
def main():
    time.sleep(1)
    while(True):
        with open('cpuandmemory.txt','a+', encoding='utf-8') as f:
            log = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+'  CPU:'+str(psutil.cpu_percent())+'% MEM:'+str(psutil.virtual_memory().percent)
            f.write(str(log)+'\n')
            print(log)
        time.sleep(60)
           
 
if __name__=="__main__":
    main()