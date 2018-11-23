#脚本数据脱敏
import os

def maskline(line):
    list = line.split()
    list[2] = 'xxx'
    return ' '.join(list)+'\n'

def maskfile(file):
    print('mask file : '+file)
    with open(file, 'r', encoding='utf-8') as f1,open('%s.bak' % file, 'w', encoding='utf-8') as f2:
        for line in f1:
            if line.find('set ')==0 and line.find('stty')==-1:
                line = maskline(line)
            f2.write(line)
    os.remove(file)
    os.rename('%s.bak' % file, file)

rootdir = os.getcwd() 
me = os.path.basename(__file__)
print('I am : '+me)
list = os.listdir(rootdir) 
for i in range(0,len(list)):
       path = os.path.join(rootdir,list[i])
       if os.path.isfile(path) and path.find(me)==-1:
           maskfile(path)


