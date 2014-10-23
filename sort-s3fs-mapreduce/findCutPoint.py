import sys
import os
import re

partNum=int(sys.argv[1])
if partNum < 2:
    print >>sys.stderr, 'Num of parts too small:%d' % (partNum)
    exit()

recordList=[]
times=50
readNum=partNum*times
ern=[int(readNum/(len(sys.argv)-2)) for i in range(2,len(sys.argv))]
remain=readNum-int(readNum/(len(sys.argv)-2))*(len(sys.argv)-2))
for i in range(0,remain):
    ern[i]+=1

for ernIndex, filePath in enumerate(sys.argv[2:]):
    if not os.path.isfile(filePath):
        print >> sys.stderr, 'findCutPoint error: file Path \"%s\" not exist.' % (filePath)
    f=open(filePath, 'r')
    for i in range(0,ern[ernIndex]):
        record=f.readline()
        while not record:
            record=f.readline()
        recordList.append(record)

recordList.sort(key=lambda x:x[:10])
recordList=recordList[times::times]
print ''.join(recordList)
