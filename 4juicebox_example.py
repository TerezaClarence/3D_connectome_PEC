# -*- coding: utf-8 -*-

import numpy as np
from mirnylib import genome
from mirnylib import h5dict
from mirnylib.numutils import externalMergeSort
import myut
import sys
import os

name='bulk_A_DpnII-HinfI'
refp='hg38'
wd2 = '/PATH/files'
name='HiCsample_A_DpnII-HinfI-MboI'
tmp= '/PATH/temp'

name=sys.argv[1]
refp=sys.argv[2]
wd2 = sys.argv[3]
tmp= sys.argv[4]

refc='/PATH/ref/'+refp+'/chr/'
###
def getChunks(N, chunkSize=100000000):
        if chunkSize > 0.5 * N:
            return [(0, N)]
        points = range(0, N - chunkSize / 2, chunkSize) + [N]
        return zip(points[:-1], points[1:])
def mysorter(x):
    inds = np.lexsort((x["cuts2"],x['cuts1'],x["chrms2"],x["chrms1"]))
    toret = x.view(np.dtype((str, x.dtype.itemsize)))[inds].view(x.dtype)
    assert len(toret) == len(x)
    assert toret.dtype == x.dtype
    return toret
def mysearchsorted(array, element):
    "matching searchsorted"
    c1 = array["chrms1"]
    p1 = array["cuts1"]
    c2 = array["chrms2"]
    p2 = array["cuts2"]

    l1=np.searchsorted(c1,element[0],'left')
    h1=np.searchsorted(c1,element[0],'right')
    l2=np.searchsorted(c2[l1:h1],element[2],'left')+l1
    h2=np.searchsorted(c2[l1:h1],element[2],'right')+l1
    l3=np.searchsorted(p1[l2:h2],element[1],'left')+l2
    h3=np.searchsorted(p1[l2:h2],element[1],'right')+l2
    toret= np.searchsorted(p2[l3:h3], element[3], "right")+l3
    return toret
def outputwriter(sdata,out1,chunksize=100000):
    #sdata = mydict.get_dataset("sortedData")
    mychunk=getChunks(N,chunksize)
    for start,end in mychunk:
        z=sdata[start:end]
        chr1=tfm[z['chrms1']]
        chr2=tfm[z['chrms2']]
        strs=['0\t{0}\t{1}\t0\t0\t{2}\t{3}\t1'.format(chr1[y],z['cuts1'][y],chr2[y],
          z['cuts2'][y]) for y in range(end-start)]
        output_str='\n'.join(strs)+'\n'
        out1.stdin.write(output_str)
    out1.communicate()
in1=h5dict.h5dict(wd2+'/hdf5/'+name+'_refinedm.hdf5',mode='r')
genome_db = genome.Genome(refc, chrmFileTemplate="chr%s.fa", readChrms=['#','X','Y'])
dic1=genome_db.idx2label.copy()
tfm=np.array([dic1[x] for x in sorted(dic1)])

N=in1.get_dataset("chrms1").shape[0]
tmpFile1 = os.path.join(tmp, str(np.random.randint(0, 100000000)))
tmpFile2 = os.path.join(tmp, str(np.random.randint(0, 100000000)))
mydict1 = h5dict.h5dict(tmpFile1,'w')
mydict2 = h5dict.h5dict(tmpFile2,'w')
mydtype = np.dtype("i1,i4,i1,i4")
mydtype.names = ("chrms1","cuts1","chrms2","cuts2")
data = mydict1.add_empty_dataset("sortedData", (N,), mydtype)
trash = mydict2.add_empty_dataset("trash", (N,), mydtype) 
chunks=getChunks(N)

for start,end in chunks:
    z=np.empty(end-start,dtype=mydtype)
    for i in mydtype.names:
        z[i]=in1.get_dataset(i)[start:end]
    data[start:end]=z
externalMergeSort(data,trash,chunkSize=500000000,sorter=mysorter,
                  searchsorted=mysearchsorted)
sdata = mydict1.get_dataset("sortedData")
out1=myut.gzipWriter(tmp+'/'+name+'_hic.txt.gz')
outputwriter(sdata,out1)
os.remove(tmpFile1)
os.remove(tmpFile2)
