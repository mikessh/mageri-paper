int i = 0
new File(args[1]).withPrintWriter { pw ->
	new File(args[0]).eachLine { line ->

    	if (++i%4==0) 
        	line = line.collect { (char)Math.min(73, (int)it) }.join("")
    
    	pw.println(line)
    
    	if (i%100000 == 0)
    		println "Processed $i reads"
        
	}
}