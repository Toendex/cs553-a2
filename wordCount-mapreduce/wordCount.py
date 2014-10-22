import sys
import os
import re
from collections import Counter

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv[1:])
cnt=Counter()
index=int(sys.argv[1])
outputFileNum=int(sys.argv[2])
for fileName in sys.argv[3:]:
    if not os.path.isfile(fileName):
        print >> sys.stderr, 'wordcount error: file name \"%s\" not exist.' % (fileName)
    f=open(fileName, 'r')
    token=filter(None,re.split('\W+', f.read().decode('utf-8'), flags=re.UNICODE))
    cnt.update(token)

filePatten=os.path.dirname(sys.argv[3])+'/../output/countInter-'+str(index)+'-'

outputFileList=[]
for i in range(0,outputFileNum):
    f=open(filePatten+str(i))
    outputFileList.append(f)

for word,num in cnt.items():
    i=hash(word)%outputFileNum
    outstr='%d\t%s\n' % (num, word)
    outputFileList[i].write(outstr.encode('utf-8'))

for f in outputFileList:
    f.close()
