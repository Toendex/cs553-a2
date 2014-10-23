import sys
import os
import re
from collections import Counter
from itertools import izip

#print 'Number of arguments:', len(sys.argv), 'arguments.'
#print 'Argument List:', str(sys.argv[1:])
cnt=Counter()
for fileName in sys.argv[1:]:
    if not os.path.isfile(fileName):
        print >> sys.stderr, 'final error: file name \"%s\" not exist.' % (fileName)
    f=open(fileName, 'r')
    token=filter(None,re.split('\W+', f.read().decode('utf-8'), flags=re.UNICODE))
    cnt.update({token[i+1]:int(token[i]) for i in range(0,len(token),2)})
outstr = '\n'.join(['%d\t%s' % (num, word) for word,num in sorted(cnt.items())])
print outstr.encode('utf-8')