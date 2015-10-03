This repository contains scripts that can be used to reproduce analysis reported in paper describing [MAGERI](https://github.com/mikessh/mageri) software.

The following sample sets are considered:

* ``p127`` - negative control, normal blood DNA (two samples)
* ``p126-2`` and ``p126-3`` - positive control samples, each containing variants described in ``h4_hd734_variants.vcf`` at a ~0.1% rate
* ``p92`` - matched blood plasma and tumor samples from two patients
* ``duplex`` - data from duplex sequencing protocol as reported by Schmitt MW *et al.* Nat Met 2015

The ``process/`` folder contains instructions for data pre-processing.

To reproduce figures reported in present paper run:

```bash
groovy GenerateTable.groovy
Rscript main_text.R
Rscript suppl.R
```

Requires both [R](https://www.r-project.org/) and [Groovy](http://www.groovy-lang.org/) to be installed for running.