import sys
import os
import re

index=int(sys.argv[1])
outputFileNum=int(sys.argv[2])
cutPointsFilePath=sys.argv[3]
recordList=[]
'''
if not os.path.isfile(cutPointsFilePath):
    print >> sys.stderr, 'wordcount error: file Path \"%s\" not exist.' % (filePath)
cutpointsFile=open(cutpointsFile, 'r')
'''
for filePath in sys.argv[4:]:
    if not os.path.isfile(filePath):
        print >> sys.stderr, 'wordcount error: file Path \"%s\" not exist.' % (filePath)
    f=open(filePath, 'r')
    recordList.extend(filter(None,f.read().split('\r\n')))

recordList.sort(key=lambda x:x[:10])

f=open("sorted",'w')
f.write('\r\n'.join(recordList))
f.close()

"""
filePath=os.path.dirPath(sys.argv[3])+'/../output/'+str(index)+'/';
if not os.path.exists(filePath):
    os.makedirs(filePath)

outputFileList=[]
for i in range(0,outputFileNum):
    f=open(filePath+str(i)+'.txt','w')
    outputFileList.append(f)

for word,num in cnt.items():
    i=hash(word)%outputFileNum
    outstr='%d\t%s\n' % (num, word)
    outputFileList[i].write(outstr.encode('utf-8'))

for f in outputFileList:
    f.close()
"""