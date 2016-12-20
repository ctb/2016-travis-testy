#! /bin/bash

### hidden code block at 2-diginorm.rst:13

set -x
set -e

### code block at 2-diginorm.rst:27

 set -u
 printf "\nMy QC-trimmed files are in $PROJECT/quality/, and consist of $(ls -1 ${PROJECT}/quality/*.qc.fq.gz | wc -l) files\n\n"
 set +u

### code block at 2-diginorm.rst:38

 source ~/pondenv/bin/activate

### code block at 2-diginorm.rst:46


 cd ${PROJECT}
 mkdir -p diginorm
 cd diginorm
 ln -s ../quality/*.qc.fq.gz .


### code block at 2-diginorm.rst:54

 normalize-by-median.py -p -k 20 -C 20 -M 4e9 \
  --savegraph normC20k20.ct -u orphans.qc.fq.gz \
  *.pe.qc.fq.gz

### code block at 2-diginorm.rst:76

 filter-abund.py -V -Z 18 normC20k20.ct *.keep && \
   rm *.keep normC20k20.ct

### code block at 2-diginorm.rst:90

 for file in *.pe.*.abundfilt
 do 
   extract-paired-reads.py ${file} && \
         rm ${file}
 done

### code block at 2-diginorm.rst:99

 gzip -9c orphans.qc.fq.gz.keep.abundfilt > orphans.keep.abundfilt.fq.gz && \
    rm orphans.qc.fq.gz.keep.abundfilt
 for file in *.pe.*.abundfilt.se
 do
    gzip -9c ${file} >> orphans.keep.abundfilt.fq.gz && \
        rm ${file}
 done

### code block at 2-diginorm.rst:110

 for file in *.abundfilt.pe
 do
   newfile=${file%%.fq.gz.keep.abundfilt.pe}.keep.abundfilt.fq
   mv ${file} ${newfile}
   gzip ${newfile}
 done
