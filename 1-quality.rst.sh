#! /bin/bash

### hidden code block at 1-quality.rst:6

set -x
set -e

### code block at 1-quality.rst:12

pip show screed

set -u
printf "\nMy raw data is in $PROJECT/data/, and consists of $(ls -1 ${PROJECT}/data/*.fastq.gz | wc -l) files\n\n"
set +u

### code block at 1-quality.rst:23

source ~/pondenv/bin/activate

### code block at 1-quality.rst:31

cd ${PROJECT}
mkdir -p quality
cd quality

### code block at 1-quality.rst:38

ln -s ../data/*.fastq.gz .

### code block at 1-quality.rst:45

printf "I see $(ls -1 *.fastq.gz | wc -l) files here.\n"

### code block at 1-quality.rst:95

wget https://anonscm.debian.org/cgit/debian-med/trimmomatic.git/plain/adapters/TruSeq3-PE.fa

### code block at 1-quality.rst:117

rm -f orphans.qc.fq.gz
for filename in *_R1_*.fastq.gz
do
     # first, make the base by removing fastq.gz
     base=$(basename $filename .fastq.gz)
     echo $base
     
     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2
     
     # finally, run Trimmomatic
     TrimmomaticPE ${base}.fastq.gz ${baseR2}.fastq.gz \
        ${base}.qc.fq.gz s1_se \
        ${baseR2}.qc.fq.gz s2_se \
        ILLUMINACLIP:TruSeq3-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25
     
     # save the orphans
     gzip -9c s1_se s2_se >> orphans.qc.fq.gz
     rm -f s1_se s2_se
done

### code block at 1-quality.rst:160

for filename in *_R1_*.qc.fq.gz
do
     # first, make the base by removing .extract.fastq.gz
     base=$(basename $filename .qc.fq.gz)
     echo $base
     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2
     # construct the output filename
     output=${base/_R1_/}.pe.qc.fq.gz
     (interleave-reads.py ${base}.qc.fq.gz ${baseR2}.qc.fq.gz | \
         gzip > $output) && rm ${base}.qc.fq.gz ${baseR2}.qc.fq.gz
done

### code block at 1-quality.rst:188

chmod u-w *.pe.qc.fq.gz orphans.qc.fq.gz

### code block at 1-quality.rst:196

rm *.fastq.gz
