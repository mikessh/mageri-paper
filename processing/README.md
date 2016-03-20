### Data download and processing

This directory contains scripts and metadata files required to reproduce data processing for MAGERI paper.

In order to download all samples for the analysis install [SRA toolkit](http://www.ncbi.nlm.nih.gov/sra), [Entrez Utilities](http://www.ncbi.nlm.nih.gov/books/NBK25501/) and run the following command:

```bash
for p in PRJNA275267 PRJNA297719 PRJNA272736
do
   esearch -db sra -query $p | \ 
   efetch --format runinfo | \ 
   cut -d ',' -f 1 | grep SRR | \ 
   xargs fastq-dump --split-files
done
```

**IMPORTANT** For "duplex" project FASTQ files make sure you've capped the max quality values by ``40``, otherwise MAGERI will exit with an exception(this also applies to other datasets with max quality of Phred ``50``). Use the following script:

```bash
groovy FixQual.groovy SRR1799908_1.fastq SRR1799908_1.fastq.q
groovy FixQual.groovy SRR1799908_2.fastq SRR1799908_2.fastq.q
```

FASTQ files should be placed in the root of this folder, after that execute ``bash process.sh``.

Make sure you've checked consistency of *.index.txt files and FASTQ file names and specified correct path to MAGERI in the shell script.