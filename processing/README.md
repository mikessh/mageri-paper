This directory contains scripts and metadata files required to reproduce data processing for MAGERI paper.

FASTQ files should be placed in the root of this folder, after that execute ``bash process.sh``. 
Make sure you've checked consistency of *.index.txt files and FASTQ file names and specified correct path to MAGERI in the shell script.

For "duplex" project FASTQ files make sure you've capped the max quality values by 40 to make MAGERI work:
```
groovy FixQual.groovy SRR1799908_1.fastq SRR1799908_1.fastq.q
groovy FixQual.groovy SRR1799908_2.fastq SRR1799908_2.fastq.q
```