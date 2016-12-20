#! /bin/bash

### code block at 3-big-assembly.rst:12

set -u
printf "\nMy diginormed files are in $PROJECT/diginorm/, and consist of $(ls -1 ${PROJECT}/diginorm/*.keep.abundfilt.fq.gz | wc -l) files\n\n"
set +u

### code block at 3-big-assembly.rst:23

source ~/pondenv/bin/activate


### code block at 3-big-assembly.rst:32

cd ${PROJECT}
mkdir -p assembly
cd assembly

### code block at 3-big-assembly.rst:42

 for file in ../diginorm/*.pe.qc.keep.abundfilt.fq.gz
 do
    split-paired-reads.py ${file}
 done

 cat *.1 > left.fq
 cat *.2 > right.fq

 gunzip -c ../diginorm/orphans.keep.abundfilt.fq.gz >> left.fq

### code block at 3-big-assembly.rst:58

 Trinity --left left.fq \
  --right right.fq --seqType fq --max_memory 14G \
  --CPU 2
