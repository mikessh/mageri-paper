def input = args[0], 
	outputFa = args[1],
	outputBed = args[2], flank = args.length > 3 ? args[3].toInteger() : 0

def badChrom = false, existing = false
def signatureSet = new HashSet<String>()
new File(outputFa).withPrintWriter { pwFa ->
new File(outputBed).withPrintWriter { pwBed ->
	pwBed.println("#chr\tstart\tend\tname\tunused\tstrand")
	new File(input).eachLine { line ->
		if (line.startsWith(">")) {
			def splitLine = line[1..-1].split("\\|")
			badChrom = splitLine[2].length() > 5
			def signature = splitLine[2..4].join("_")
			existing = signatureSet.contains(signature)

			if (!badChrom && !existing) {
				signatureSet.add(signature)

				def faName = splitLine[0] + "_" + splitLine[1]

				pwFa.println(">" + faName)
				
				pwBed.println([
					(splitLine[2].startsWith("chr") ? "" : "chr") + splitLine[2],
					splitLine[3].toInteger() - flank - 1,
					splitLine[4].toInteger() + flank,
					faName,
					"0",
					splitLine[5].toInteger() >= 0 ? "+" : "-"
				].join("\t")
				)
			}
		} else {
			if (!badChrom && !existing)
				pwFa.println(line)
		}
	}
}
}