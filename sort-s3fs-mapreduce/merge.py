import sys
import os
import re

recordList=[]

for filePath in sys.argv[1:]:
    if not os.path.isfile(filePath):
        print >> sys.stderr, 'merge error: file Path \"%s\" not exist.' % (filePath)
    f=open(filePath, 'r')
    recordList.extend(filter(None,f.read().split('\r\n')))

recordList.sort(key=lambda x:x[:10])

print '\r\n'.join(recordList)+'\r\n',
