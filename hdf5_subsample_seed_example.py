#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import numpy as np
from mirnylib import genome
from mirnylib import h5dict
from mirnylib.numutils import externalMergeSort
import myut
import sys
import os

np.random.seed(42)

inname=sys.argv[1]
output=sys.argv[2]
tmp=sys.argv[3]
factor=float(sys.argv[4])
'''
name='G_A_MboI'
wd2 = '/PATH/hicpro/'
tmp= '/PATH/temp'
factor=0.649
'''
def getChunks(N, chunkSize=100000000):
        if chunkSize > 0.5 * N:
            return [(0, N)]
        points = range(0, N - chunkSize / 2, chunkSize) + [N]
        return zip(points[:-1], points[1:])

mydtype = np.dtype("i1,i4,b1,i1,i4,b1")
mydtype.names = ("chrms1","cuts1","strands1","chrms2","cuts2",'strands2')

in1=h5dict.h5dict(inname,mode='r')
N=in1.get_dataset("chrms1").shape[0]
chunks=getChunks(N)
tmpfile = os.path.join(tmp, os.path.basename(inname)+'_tmp.hdf5')
out1=h5dict.h5dict(tmpfile,mode='w')
out2=h5dict.h5dict(output,mode='w')
for i in mydtype.names:
    out1.add_empty_dataset(i, (N,), mydtype[i])

### step1, get the sub samples to temp file1
n=0;st=0
for start,end in chunks:
    z=np.empty(end-start,dtype=mydtype)
    for i in mydtype.names:
        z[i]=in1.get_dataset(i)[start:end]
    z=z[np.random.rand(len(z))<factor]
    if (len(z)>0):
        ed=st+len(z)
        for i in mydtype.names:
            out1.get_dataset(i)[st:ed]=z[i]
        n+=len(z)
        st=ed

for i in mydtype.names:
    out2.add_empty_dataset(i, (n,), mydtype[i])

chunks=getChunks(n)
for start,end in chunks:
    for i in mydtype.names:
        out2.get_dataset(i)[start:end]=out1.get_dataset(i)[start:end]
out2['metadata']=in1['metadata']
out2.flush()
os.remove(tmpfile)
