MAGERI="java -Xmx40G -jar mageri-1.1.1-SNAPSHOT-distribution.jar"

for n in default 5 10 15 20 25 30 100
do
$MAGERI --import-preset preset_$n.xml -M4 --project-name 7mix_$n --contigs meta/contigs_hg38.txt --bed meta/cgc_exons_flank50.bed --references meta/cgc_exons_flank50.fa -R1 7mix_u.fastq -O out/
done