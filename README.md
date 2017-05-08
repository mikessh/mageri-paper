## Supplementary data for MAGERI software

This repository contains scripts that can be used to reproduce analysis reported in paper describing [MAGERI](https://github.com/mikessh/mageri) software.
Raw sequencing datasets can be downloaded from SRA, accession [PRJNA297719](http://www.ncbi.nlm.nih.gov/bioproject/PRJNA297719)

The following sample sets were used in the original manuscript:

* ``p127`` - negative control, normal blood DNA (two samples)
* ``p126-2`` and ``p126-3`` - positive control samples, each containing variants described in ``h4_hd734_variants.vcf`` at a ~0.1% rate
* ``p92`` - matched blood plasma and tumor samples from two patients
* ``duplex`` - data from duplex sequencing protocol as reported by Schmitt MW *et al.* Nat Met 2015, available in [SRA](http://trace.ddbj.nig.ac.jp/DRASearch/run?acc=SRR1799908)
* ``hiv`` - data from UMI-tagged HIV sequencing as reported by Zhou S *et al.* J Virol 2015, available in [SRA](http://trace.ddbj.nig.ac.jp/DRASearch/experiment?acc=SRX844885)

The ``process/`` folder contains instructions for data download and pre-processing. Other folders in the repository root contain MAGERI results for analyzed datasets.

To reproduce figures reported in present paper run:

```bash
groovy GenerateTable.groovy
Rscript main_text.R
Rscript suppl.R
```

Requires both [R](https://www.r-project.org/) and [Groovy](http://www.groovy-lang.org/) to be installed for running.

## Citation

Please cite [Shugay et al. Plos Comp Biol 2017](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005480) in case you use our datasets.