MAGERI="java -Xmx64G -jar mageri-1.0.0.jar"
mkdir output/; rm output/log.txt; touch output/log.txt
for p in p127 p126-2 p126-3 p92 duplex
do
   $MAGERI -I $p.json -O output/ | tee output/log.txt
done