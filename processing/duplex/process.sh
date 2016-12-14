MAGERI="java -Xmx64G -jar mageri-1.1.1-SNAPSHOT-distribution.jar"
mkdir output/;

$MAGERI --import-preset duplex_preset.xml -I duplex.json -O output/duplex/ | tee output/duplex.log.txt