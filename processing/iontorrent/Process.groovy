
def updateHeader = { String header ->
    def umi = header.split("_")[2][2..13]

    header + " UMI:" + umi + ":" + ("I" * umi.length())
}

int i = 0
new File("7mix_u.fastq").withPrintWriter { pw ->
new File("7mix.fastq").eachLine { line ->
  pw.println(i % 4 == 0 ? updateHeader(line) : line)
  i++
  if (i % 400000 == 0) {
    println("[" + new Date() + "] Processed ${i / 4} reads") 
  }
}
}