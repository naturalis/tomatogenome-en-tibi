#!/usr/bin/env python
#explanation:this program is edited to cat the SoapBychrSort.list 2 a sortfile
#edit by HeWeiMing;   Mon Aug  2 17:20:32 CST 2010
#Version 1.0    hewm@genomics.org.cn
import sys
try:
     flist = open(sys.argv[1],"r")
except IndexError:
     print >>sys.stderr, "\tVersion 1.0\thewm@genomics.org.cn\t2010-10-10;"
     print >>sys.stderr, "\tpython",sys.argv[0],"SoapBychrSort.list > OutPut"
     sys.exit(1)

FH = {}
def run (fh, pos):
    try:
        data = fh.next()
    except:
        fh.close()
        return 'NULL'
    if data.split()[8] <= pos:
        sys.stdout.write(data)
        data = run(fh, pos)
    return data

def chose_fh ( filehandles ):
    chosed_fh = filehandles[0]
    for fh in filehandles:
        if int(FH[fh].split()[8]) < int(FH[chosed_fh].split()[8]):
            chosed_fh = fh
    return chosed_fh

for fname in flist:
    fh = open(fname[:-1], 'r')
    try:
       FH[fh] = fh.next()
    except:
       fh.close()
flist.close

while FH.__len__():
    fh = chose_fh(FH.keys())
    sys.stdout.write(FH[fh])
    data = run(fh, int(FH[fh].split()[8]))
    if data == 'NULL':
        del FH[fh]
    else:
        FH[fh] = data


####swimming in the sky and flying in the sea ################
