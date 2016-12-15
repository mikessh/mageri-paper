for p in PRJNA272736
do
   ../edirect/esearch -db sra -query $p | ../edirect/efetch --format runinfo | cut -d ',' -f 1 | grep SRR | xargs ../sra-tk/bin/fastq-dump --split-files
done
