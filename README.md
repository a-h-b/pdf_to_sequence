# pdf_to_sequence

Requirements: R packages pdftools, stringr, rentrez, data.table

load libraries
```
library(pdftools)
library(stringr)
library(rentrez)
library(data.table)
```

source script to load functions:
```
source("pdf2sequence.R")
```

get accessions for pdf:

```
accs <- paper2acc("myPDF.pdf")
accs
```

get sample table for accession, e.g. SRP118372:

```
runTable <- acc2runtable("SRP118372")
```

get run table from paper:
```
runTable2 <- acc2runtable(paper2acc("myPDF.pdf"))
```

more to come ... 
