MAGERI="java -Xmx64G -jar mageri-1.1.1-SNAPSHOT-distribution.jar"
mkdir output/;

for p in p126 p127 p92
do
   $MAGERI --import-preset preset.xml -I $p.json -O output/$p/ | tee output/$p.log.txt
done