MAGERI="java -Xmx64G -jar mageri-1.1.1-SNAPSHOT-distribution.jar"
mkdir output/;

$MAGERI --import-preset preset.xml -I hiv.json -O output/hiv/ | tee output/hiv.log.txt
