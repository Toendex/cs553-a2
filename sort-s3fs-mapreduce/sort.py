import sys
import os
import re

index=int(sys.argv[1])
cutPointsFilePath=sys.argv[2]
recordList=[]

if not os.path.isfile(cutPointsFilePath):
    print >> sys.stderr, 'wordcount error: file Path \"%s\" not exist.' % (filePath)
cutpointsFile=open(cutPointsFilePath, 'r')

for filePath in sys.argv[3:]:
    if not os.path.isfile(filePath):
        print >> sys.stderr, 'sort error: file Path \"%s\" not exist.' % (filePath)
    f=open(filePath, 'r')
    recordList.extend(filter(None,f.read().split('\r\n')))

recordList.sort(key=lambda x:x[:10])
filePath=os.path.dirname(sys.argv[3])+'/../output/'+str(index)+'/';
if not os.path.exists(filePath):
    os.makedirs(filePath)
lastPoint=0
nowPoint=0
i=0
for label in filter(None, cutpointsFile.read().split('\r\n')):
    while nowPoint < len(recordList) and recordList[nowPoint][:10] < label[:10]:
        nowPoint+=1
    f=open(filePath+str(i)+'.txt','w')
    if not lastPoint == nowPoint:
        f.write('\r\n'.join(recordList[lastPoint:nowPoint]))
        f.write('\r\n')
    f.close()
    i+=1
    lastPoint=nowPoint
f=open(filePath+str(i)+'.txt','w')
if lastPoint < len(recordList):
    f.write('\r\n'.join(recordList[lastPoint:]))
    f.write('\r\n')
f.close()
