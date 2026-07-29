# 3D_connectome_PEC
Analysis script and reproducibility for HiC lifespan atlas (PsychENCODE 2026-2027)



# PsychENCODE Hi-C Lifespan Manuscript

[![Repository status](https://img.shields.io/badge/status-in%20development-orange)](#)
[![Data](https://img.shields.io/badge/data-Synapse-blue)](#data-availability)
[![R](https://img.shields.io/badge/language-R-276DC3)](#software-environments)
[![Python](https://img.shields.io/badge/language-Python-3776AB)](#software-environments)

This repository contains analysis scripts and figure-reproduction notebooks associated with:

> **Manuscript title:** *XXX*
> **Authors:** XXX
> **Citation:** XXX

The repository is organized by manuscript figure. Each `FIG1`–`FIG5` directory contains scripts for the principal analyses presented in the corresponding manuscript section, together with a Jupyter notebook demonstrating how key panels can be reproduced from the deposited supplementary tables and supplementary data.

---

## 📦 Data availability

Hi-C contact matrices, supplementary tables, and supplementary data associated with this manuscript are deposited in Synapse:

* **Synapse ID:** `synID XXX`
* **Synapse repository:** [XXX](XXX)

Chrom3D-derived three-dimensional genome models are deposited in the same Synapse repository.

> **Note:** Access to some data may be subject to the data-use, governance, or controlled-access requirements of the original PsychENCODE datasets.

---

## 💻 Software environments

Package versions used for the analyses are provided in the following files:

* [`python_requirements.txt`](python_requirements.txt): Python packages and versions
* [`R_requirements.txt`](R_requirements.txt): R packages and versions

We recommend recreating the documented software environments before running the analysis or figure-reproduction workflows.

---

## 🗂️ Repository structure

```text
.
├── FIG1/
│   ├── celltype_pseudobulk_prep.R
│   ├── HiCrep_analysis.R
│   └── FIG1_plots.ipynb
│
├── FIG2/
│   ├── cisdecay.py
│   ├── SVL.py
│   ├── 3DG_spatial_analysis.py
│   └── FIG2_plots.ipynb
│
├── FIG3/
│   ├── calder2.R
│   ├── lifespan_category_subcpt.py
│   ├── gsea_subcpt.R
│   ├── avgGEX_BioModule.R
│   └── FIG3_plots.ipynb
│
├── FIG4/
│   ├── TimeCompare.R
│   ├── TADtree.R
│   ├── DoD.R
│   ├── TADdynamics_BioModule.R
│   ├── DoD_BioModule.R
│   └── FIG4_plots.ipynb
│
├── FIG5/
│   ├── gnocchi_analysis.R
│   ├── gnomAD_LOEUF_analysis.R
│   ├── STR_analysis.R
│   ├── multiomic_mapping_prioritizedSTRloci.R
│   └── FIG5_plots.ipynb
│
├── python_requirements.txt
├── R_requirements.txt
└── README.md
```

---

## 🧬 Figure 1: Hi-C atlas generation and data quality

The `FIG1` directory contains scripts used for cell type- and age group-specific Hi-C pseudobulk preparation, contact-map concordance analysis, and reproduction of selected Figure 1 panels.

| File                         | Description                                                                                |
| ---------------------------- | ------------------------------------------------------------------------------------------ |
| `celltype_pseudobulk_prep.R` | Example workflow for preparing cell type- and age group-specific pseudobulk Hi-C matrices. |
| `HiCrep_analysis.R`          | HiCRep analysis for quantifying concordance between Hi-C contact matrices.                 |
| `FIG1_plots.ipynb`           | Reproducibility examples for selected plots presented in Figure 1.                         |

---

## 🌐 Figure 2: Interaction scaling and three-dimensional genome organization

The `FIG2` directory contains scripts for genomic distance-dependent contact analysis and spatial analysis of Chrom3D-derived genome models.

| File                      | Description                                                                                                                                  |
| ------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `cisdecay.py`             | Cis-decay analysis of contact frequency as a function of genomic distance.                                                                   |
| `SVL.py`                  | Analysis of the short-range versus long-range interaction ratio.                                                                             |
| `3DG_spatial_analysis.py` | Mapping of gene modules onto Chrom3D-derived three-dimensional genome models, including spatial colocalization and model-stability analyses. |
| `FIG2_plots.ipynb`        | Reproducibility examples for selected plots presented in Figure 2.                                                                           |

---

## 🧭 Figure 3: Lifespan subcompartment dynamics

The `FIG3` directory contains scripts for chromatin subcompartment inference, lifespan category assignment, gene-set enrichment, and integration with cell type- and age group-resolved gene expression.

| File                          | Description                                                                                                           |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `calder2.R`                   | Chromatin subcompartment inference using CALDER2.                                                                     |
| `lifespan_category_subcpt.py` | Assignment of lifespan subcompartment category labels.                                                                |
| `gsea_subcpt.R`               | Gene-set enrichment analysis of selected subcompartment categories.                                                   |
| `avgGEX_BioModule.R`          | Preparation of average cell type- and age group-specific gene-expression values for gene sets used in the manuscript. |
| `FIG3_plots.ipynb`            | Reproducibility examples for selected plots presented in Figure 3.                                                    |

---

## 🏗️ Figure 4: TAD dynamics, hierarchy, and degree of disorder

The `FIG4` directory contains scripts for lifespan TAD classification, hierarchical TAD organization, degree-of-disorder analysis, and downstream analysis of selected biological gene modules.

| File                      | Description                                                                                 |
| ------------------------- | ------------------------------------------------------------------------------------------- |
| `TimeCompare.R`           | Assignment of lifespan TAD category labels using TimeCompare.                               |
| `TADtree.R`               | Hierarchical TAD analysis, including evaluation of TAD nesting.                             |
| `DoD.R`                   | Degree-of-disorder analysis of TAD organization.                                            |
| `TADdynamics_BioModule.R` | Downstream analysis of selected manuscript gene sets across lifespan TAD categories.        |
| `DoD_BioModule.R`         | Downstream analysis of selected manuscript gene sets in relation to TAD degree of disorder. |
| `FIG4_plots.ipynb`        | Reproducibility examples for selected plots presented in Figure 4.                          |

---

## 🧩 Figure 5: Functional constraint and disease-associated repeat loci

The `FIG5` directory contains scripts for integrating TAD categories with noncoding constraint, gene-level loss-of-function constraint, short tandem repeat loci, and multiomic data.

| File                                     | Description                                                                               |
| ---------------------------------------- | ----------------------------------------------------------------------------------------- |
| `gnocchi_analysis.R`                     | Analysis of Gnocchi noncoding constraint scores across TAD categories.                    |
| `gnomAD_LOEUF_analysis.R`                | Analysis of gnomAD LOEUF gene-constraint scores across TAD categories.                    |
| `STR_analysis.R`                         | Analysis of disease-associated short tandem repeat loci across TAD categories.            |
| `multiomic_mapping_prioritizedSTRloci.R` | Multiomic visualization and locus-level analysis of prioritized short tandem repeat loci. |
| `FIG5_plots.ipynb`                       | Reproducibility examples for selected plots presented in Figure 5.                        |

---

## 🧊 Chrom3D modelling tutorial

A separate tutorial describing the Chrom3D modelling workflow is available in the following repository:

* **Chrom3D tutorial:** [XXX](XXX)

The tutorial repository provides detailed guidance for generating Chrom3D models. The present repository focuses on downstream spatial analyses of the Chrom3D-derived models used in the manuscript.

---

## ▶️ Reproducing manuscript figures

To reproduce selected manuscript plots:

1. Obtain the required supplementary tables, supplementary data, and model outputs from the Synapse repository.
2. Recreate the relevant R and Python software environments using `R_requirements.txt` and `python_requirements.txt`.
3. Follow the input-file instructions provided within each script or notebook.
4. Run the analysis scripts associated with the relevant manuscript figure.
5. Open the corresponding `FIG*_plots.ipynb` notebook to reproduce selected figure panels.

The notebooks are intended to provide transparent examples of figure generation from the deposited supplementary data. Some computationally intensive upstream analyses, including Hi-C matrix processing and three-dimensional genome modelling, may require additional computing resources.

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
