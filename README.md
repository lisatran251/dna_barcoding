# DNA Barcoding 

A lightweight, reproducible workflow for COI-based DNA barcoding: from raw sequences to taxonomic assignments and summary reports.

**Repository:** [https://github.com/lisatran251/dna\_barcoding/](https://github.com/lisatran251/dna_barcoding/)

## Overview

This project streamlines common DNA barcoding tasks:

* Basic QC of sequences
* Optional trimming/length filtering
* Dereplication/OTU (or ASV) generation (if configured)
* Taxonomic assignment against a reference (e.g., BOLD/NCBI-derived COI)
* Per-sample and project summaries (tables/plots)

## Requirements

* **R** ≥ 4.1
* Recommended R packages (install if your script doesn’t already):

  * `tidyverse`, `Biostrings`, `data.table`, `readr`, `stringr`, `ggplot2`
  * Any other packages used inside `R.script`


## Quick Start

1. **Clone this repository**

   ```bash
   git clone https://github.com/lisatran251/dna_barcoding.git
   cd dna_barcoding
   ```

2. **Prepare your inputs**

   * Place FASTA/FASTQ files in `data/raw/` (or update the path in `R.script`).
   * Ensure any config variables inside `R.script` (e.g., input/output directories, filters, reference DB path) are correct.

3. **Run the pipeline**
   From an interactive R session:

   ```r
   setwd("path/to/dna_barcoding")  # if needed
   source("R.script")
   ```

   Or non-interactively:

   ```bash
   Rscript -e 'source("R.script")'
   ```

## Typical Directory Layout

```
dna_barcoding/
├─ R.script                 # Main entry point (pipeline orchestrator)
├─ data/
│  ├─ raw/                  # Input sequences (FASTA/FASTQ)
├─ results/
│  ├─ tables/               # CSV/TSV summaries
│  └─ figures/              # Plots
└─ docs/                    # Notes or reports (optional)
```

> The script will create `results/` and other folders if they don’t exist (or instruct you to do so).

## Configuration

Open `R.script` and review the “Config” section near the top:

* **Input dir**: e.g., `data/raw/`
* **Reference DB**: path to COI database (FASTA/DB) if used
* **Filters**: min/max length, max Ns, quality thresholds (if applicable)
* **Output dir**: e.g., `results/`


## Outputs

After a successful run, expect (names may vary):

* `results/bold_best_per_taxon_per_seq.csv` – taxonomic assignments per sequence/cluster

## Re-running & Reproducibility

* The pipeline can be re-run after updating inputs or parameters; previous outputs may be overwritten.
* To ensure reproducibility:

  * Record your R version: `sessionInfo()`
  * Pin packages with `renv` (recommended).

## Troubleshooting

* **`file/dir not found`**: Check the `in_dir`, `out_dir`, and `ref_path` in `R.script`.
* **Package errors**: Install missing packages:

  ```r
  install.packages(c("tidyverse","Biostrings","data.table","readr","stringr","ggplot2"))
  ```
* **Encoding issues with FASTA/FASTQ**: Ensure UTF-8 and standard line endings.
* **Reference DB mismatch**: Confirm your DB matches the assignment method configured in `R.script`.

---

**One-line run reminder:**
From R: `source("R.script")` 
