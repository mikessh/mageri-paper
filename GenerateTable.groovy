package com.milaboratory.mageri.misc

def variantMap = new HashMap<String, List<String>>()

def signatureHeader = "\tchr\tpos\tfrom\tto"

def getSignature = { List<String> vcfLine ->
    vcfLine[[0, 1, 3, 4]].join("\t")
}

def statFields = "\tfreq\tdepth\tqual\terrrate.est\tcqs"

def getFlagVal = { String[] splitLine, String flag ->
    splitLine.find { it.startsWith("$flag=") }.substring(3)
}

def getStatFields = { String processing, List<String> vcfLine ->
    if (processing.startsWith("mageri")) {
        def splitLine = vcfLine[7].split(";")
        return [getFlagVal(splitLine, "AF"),
                getFlagVal(splitLine, "DP"),
                vcfLine[5],
                getFlagVal(splitLine, "ER"),
                getFlagVal(splitLine, "CQ")].join("\t")
    } else {
        def splitLine = vcfLine[9].split(":")

        return [splitLine[6].replaceAll("%", "").replaceAll(",", ".").toDouble() / 100,
                splitLine[2],
                splitLine[1],
                "NA", "NA"
        ].join("\t")
    }
}

new File("h4_hd734_variants.vcf").splitEachLine("\t") {
    if (!it[0].startsWith("#")) {
        variantMap.put(getSignature(it), [it[2], it[7]])
    }
}

def somaticFiles = ["mageri_1"      : [1, 2, 3, 4].collect { m -> "p126/p126-2.h4_ballast_m${m}.vcf" },
                    "mageri_2"      : [1, 2, 3, 4].collect { m -> "p126/p126-3.h4_ballast_m${m}.vcf" },
                    "conventional_1": ["varscan_raw/P126_2.vcf"],
                    "conventional_2": ["varscan_raw/P126_3.vcf"]]
controlFiles = ["mageri_1"      : [1, 2, 3, 4].collect { m -> "p127/p127.ballast1_m${m}.vcf" },
                "mageri_2"      : [1, 2, 3, 4].collect { m -> "p127/p127.ballast2_m${m}.vcf" },
                "conventional_1": ["varscan_raw/P127_1.vcf"],
                "conventional_2": ["varscan_raw/P127_2.vcf"]]

new File("summary.txt").withPrintWriter { pw ->
    pw.println("processing\treplica\ttype\tname" + signatureHeader + statFields + "\tknown.freq")

    controlFiles.each { entry ->
        def (sample, replica) = entry.key.split("_")
        entry.value.each { fileName ->
            new File(fileName).splitEachLine("\t") { splitLine ->
                if (!splitLine[0].startsWith("#")) {
                    def stats = getStatFields(entry.key, splitLine)

                    /*
                     * There are only few SNP calls, lets filter them
                     * mageri	1	error	.	chr11	534242	A	G	0.49871466	778	9999
                     * mageri	1	error	.	chr19	4101062	G	T	0.4812443	2186	9999
                     * mageri	2	error	.	chr11	534242	A	G	0.48736998	673	9999
                     * mageri	2	error	.	chr19	4101062	G	T	0.5008889	2250	9999
                     */
                    def vals = stats.split("\t")[0..1].collect { it.toDouble() }
                    if (vals[0] <= 0.05 && vals[1] > 100) { // freq and depth filters
                        pw.println(sample + "\t" + replica + "\terror\t.\t" +
                                getSignature(splitLine) + "\t" + stats + "\tNA")
                    }
                }
            }
        }
    }

    somaticFiles.each { entry ->
        def (sample, replica) = entry.key.split("_")
        entry.value.each { fileName ->
            new File(fileName).splitEachLine("\t") { splitLine ->
                if (!splitLine[0].startsWith("#")) {
                    def signature = getSignature(splitLine)

                    if (variantMap.containsKey(signature)) {
                        def (name, freq) = variantMap[signature]
                        pw.println(sample + "\t" + replica + "\tsomatic\t$name\t" +
                                signature + "\t" + getStatFields(entry.key, splitLine) + "\t" + freq)
                    }
                }
            }
        }
    }
}

def captureFiles = ["mageri_1_full"  : [1, 2, 3, 4].collect { m -> "p126/p126-2.h4_ballast_m${m}.vcf" },
                    "mageri_2_full"  : [1, 2, 3, 4].collect { m -> "p126/p126-3.h4_ballast_m${m}.vcf" },
                    "mageri_1_0.1mln": [1, 2, 3, 4].collect { m -> "p126/0.1mln/p126-2.h4_ballast_m${m}.vcf" },
                    "mageri_2_0.1mln": [1, 2, 3, 4].collect { m -> "p126/0.1mln/p126-3.h4_ballast_m${m}.vcf" },
                    "mageri_1_1mln"  : [1, 2, 3, 4].collect { m -> "p126/1mln/p126-2.h4_ballast_m${m}.vcf" },
                    "mageri_2_1mln"  : [1, 2, 3, 4].collect { m -> "p126/1mln/p126-3.h4_ballast_m${m}.vcf" },
                    "mageri_1_10mln" : [1, 2, 3, 4].collect { m -> "p126/10mln/p126-2.h4_ballast_m${m}.vcf" },
                    "mageri_2_10mln" : [1, 2, 3, 4].collect { m -> "p126/10mln/p126-3.h4_ballast_m${m}.vcf" }]

new File("capture.txt").withPrintWriter { pw ->
    pw.println("processing\treplica\tsize\ttype\tname" + signatureHeader + statFields + "\tknown.freq")
    captureFiles.each { entry ->
        def (sample, replica, size) = entry.key.split("_")
        entry.value.each { fileName ->
            new File(fileName).splitEachLine("\t") { splitLine ->
                if (!splitLine[0].startsWith("#")) {
                    def signature = getSignature(splitLine)

                    if (variantMap.containsKey(signature)) {
                        def (name, freq) = variantMap[signature]
                        pw.println(sample + "\t" + replica + "\t" + size+ "\tsomatic\t$name\t" +
                                signature + "\t" + getStatFields(entry.key, splitLine) + "\t" + freq)
                    }
                }
            }
        }
    }
}