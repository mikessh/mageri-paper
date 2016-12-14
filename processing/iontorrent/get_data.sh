wget http://datadryad.org/bitstream/handle/10255/dryad.103353/7mixac?sequence=1 -O 7mixac.fastq
wget http://datadryad.org/bitstream/handle/10255/dryad.103356/7mixaa?sequence=1 -O 7mixaa.fastq
wget http://datadryad.org/bitstream/handle/10255/dryad.103357/7mixab?sequence=1 -O 7mixab.fastq
wget http://datadryad.org/bitstream/handle/10255/dryad.103358/7mixad?sequence=1 -O 7mixad.fastq
cat 7mixaa.fastq 7mixab.fastq 7mixac.fastq 7mixad.fastq > 7mix.fastq
groovy Process.groovy