# 3D_connectome_PEC

Analysis scripts and reproducibility resources for the PsychENCODE Hi-C lifespan atlas (2026–2027).

# PsychENCODE Hi-C Lifespan Connectome Manuscript

[![Repository status](https://img.shields.io/badge/status-in%20development-orange)](#)
[![Data](https://img.shields.io/badge/data-Synapse-blue)](#data-availability)
[![R](https://img.shields.io/badge/language-R-276DC3)](#software-environments)
[![Python](https://img.shields.io/badge/language-Python-3776AB)](#software-environments)

This repository contains analysis scripts and figure-reproduction notebooks associated with:

> **Manuscript title:** *XXX*  
> **Authors:** XXX  
> **Citation:** XXX

Analysis-specific scripts are maintained at the repository root so that individual workflows can be reused independently of manuscript figure organization. The `FIG1`–`FIG5` directories contain only Jupyter notebooks for reproducing selected key panels from the deposited supplementary tables and supplementary data.

---

## 💻 Software environments

Package versions used for the analyses are provided in the following files:

* [`python_requirements.txt`](python_requirements.txt): Python packages and versions
* [`R_requirements.txt`](R_requirements.txt): R packages and versions

We recommend recreating the documented software environments before running the analysis or figure-reproduction workflows.

---

## 🔬 Analysis scripts


Analysis scripts used for Hi-C processing and downstream 3D genome analyses in the PsychENCODE lifespan project.
This repository contains reusable example scripts for Hi-C format conversion and subsampling, reproducibility analysis, contact-distance analyses, subcompartment inference, TAD calling and temporal comparison, and degree-of-disorder analysis.

| Script | Description |
| --- | --- |
| `4juicebox_example.py` | Converts refined Hi-C HDF5 interaction data into a sorted gzipped text representation suitable for downstream Juicebox/Juicer-style processing. |
| `hdf5_subsample_seed_example.py` | Randomly subsamples Hi-C interactions stored in HDF5 format using a fixed random seed for reproducibility. |
| `run_hicrep.R` | Calculates pairwise Hi-C reproducibility using HiCRep, with optional depth adjustment/subsampling. |
| `run_cis_decay.sh` | Calculates contact probability as a function of genomic distance using HiCExplorer `hicPlotDistVsCounts`. |
| `run_svl.sh` | Calculates short-to-long-range contact ratios using HiCExplorer `hicPlotSVL`. |
| `run_calder2.R` | Runs CALDER2 compartment and subcompartment inference from Juicer `.hic` files. |
| `run_hicFindTAD_param_sweep.sh` | Calls TADs with HiCExplorer `hicFindTADs` across combinations of FDR and delta thresholds while reusing the separation score. |
| `run_timecompare.R` | Performs temporal TAD-boundary analysis using `TADCompare::TimeCompare` from sparse contact matrices supplied through a manifest file. |
| `run_mdknn_dod.sh` | Runs MDkNN degree-of-disorder analysis across a collection of TAD BED files. |


## Software requirements

Package lists are provided without pinned versions at this stage:

- [`python_requirements.txt`](python_requirements.txt): Python packages used by the included Python scripts
- [`R_requirements.txt`](R_requirements.txt): R packages used by the included R scripts

The shell workflows additionally require the corresponding command-line software to be installed and available in `PATH`, including **HiCExplorer** for `hicPlotDistVsCounts`, `hicPlotSVL`, and `hicFindTADs`.

`run_mdknn_dod.sh` additionally expects the MDkNN Python script (`mdknn.py`) to be available locally or supplied as an argument.

The legacy Python conversion/subsampling scripts use `mirnylib` and a local helper module named `myut`; the latter is project-specific and is therefore not listed as an installable Python package.

## Basic usage

Each script contains its own command-line usage and example invocation in the header. For example:

```bash
bash run_cis_decay.sh sample.cool sample results/cis_decay
```

```bash
bash run_svl.sh sample_40kb.h5 40000 results/SVL 4
```

```bash
bash run_hicFindTAD_param_sweep.sh sample_50kb.cool results/TADs 4
```

```bash
bash run_mdknn_dod.sh sample.cool tads/ results/DoD/
```

```bash
Rscript run_calder2.R sample.hic results/CALDER 50000 hg38 4
```

```bash
Rscript run_hicrep.R sample1.hic sample2.hic sample1 sample2 100000 results/hicrep
```

```bash
Rscript run_timecompare.R manifest.tsv 100000 sample results/timecompare
```

## Notes

These scripts are provided as reusable analysis examples. Input paths, output locations, genome references, matrix resolutions, and analysis parameters should be adjusted as appropriate for the dataset being analyzed.examples. Input paths, output locations, genome references, matrix resolutions, and analysis parameters should be adjusted as appropriate for the dataset being analyzed.


---

## 📝 Citation

When using code or resources from this repository, please cite:

> XXX

A complete citation will be added following publication of the manuscript.

---

## 📬 Contact

For questions regarding the analyses or repository contents, please contact:

* **Name:** XXX
* **Email:** XXX
* **Institution:** XXX

---

## ⚖️ Licence

This repository is currently under development and has not yet been assigned an open-source licence.

Unless otherwise stated, the absence of a licence means that reuse, redistribution, and modification are not automatically permitted. A software licence will be added when the repository is prepared for public release.
