# 3D_connectome_PEC

Analysis scripts and reproducibility resources for the PsychENCODE Hi-C lifespan atlas (2026–2027).

# PsychENCODE Hi-C Lifespan Manuscript

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
├── celltype_pseudobulk_prep.R
├── run_hicrep.R
├── run_cis_decay.sh
├── run_svl.sh
├── 3DG_spatial_analysis.py
├── run_calder2.R
├── lifespan_category_subcpt.py
├── gsea_subcpt.R
├── avgGEX_BioModule.R
├── run_timecompare.R
├── TADtree.R
├── run_mdknn_dod.sh
├── TADdynamics_BioModule.R
├── DoD_BioModule.R
├── gnocchi_analysis.R
├── gnomAD_LOEUF_analysis.R
├── STR_analysis.R
├── multiomic_mapping_prioritizedSTRloci.R
│
├── FIG1/
│   └── FIG1_plots.ipynb
├── FIG2/
│   └── FIG2_plots.ipynb
├── FIG3/
│   └── FIG3_plots.ipynb
├── FIG4/
│   └── FIG4_plots.ipynb
├── FIG5/
│   └── FIG5_plots.ipynb
│
├── python_requirements.txt
├── R_requirements.txt
└── README.md
```

The analysis scripts are intentionally kept separate from the manuscript figure directories. This allows workflows such as HiCRep, CALDER2, TimeCompare, MDkNN/DoD, constraint analyses, and Chrom3D spatial analyses to be run independently and reused across downstream analyses.

---

## 🔬 Analysis scripts

### Hi-C preprocessing, quality control, and interaction scaling

| File | Description |
| --- | --- |
| `celltype_pseudobulk_prep.R` | Example workflow for preparing cell type- and age group-specific pseudobulk Hi-C matrices. |
| `run_hicrep.R` | HiCRep analysis for quantifying concordance between Hi-C contact matrices. |
| `run_cis_decay.sh` | Genomic distance-dependent contact-frequency analysis using HiCExplorer. |
| `run_svl.sh` | Short-range versus long-range interaction analysis using HiCExplorer. |

### Three-dimensional genome organization

| File | Description |
| --- | --- |
| `3DG_spatial_analysis.py` | Spatial analysis of Chrom3D-derived genome models, including genomic-region colocalization and model-stability analyses. |

### Subcompartment analyses

| File | Description |
| --- | --- |
| `run_calder2.R` | Chromatin compartment and subcompartment inference using CALDER2. |
| `lifespan_category_subcpt.py` | Assignment of lifespan subcompartment category labels. |
| `gsea_subcpt.R` | Gene-set enrichment analysis of selected subcompartment categories. |
| `avgGEX_BioModule.R` | Preparation of average cell type- and age group-specific gene-expression values for biological modules used in downstream analyses. |

### TAD and boundary analyses

| File | Description |
| --- | --- |
| `run_timecompare.R` | Temporal TAD-boundary analysis and lifespan category assignment using TimeCompare. |
| `TADtree.R` | Hierarchical TAD analysis, including evaluation of nested TAD organization. |
| `run_mdknn_dod.sh` | MDkNN-based degree-of-disorder analysis for TADs and TAD boundaries. |
| `TADdynamics_BioModule.R` | Downstream analysis of selected biological modules across lifespan TAD categories. |
| `DoD_BioModule.R` | Downstream analysis of selected biological modules in relation to TAD degree of disorder. |

### Functional constraint and disease-associated loci

| File | Description |
| --- | --- |
| `gnocchi_analysis.R` | Analysis of Gnocchi noncoding constraint scores across TAD categories. |
| `gnomAD_LOEUF_analysis.R` | Analysis of gnomAD LOEUF gene-constraint scores across TAD categories. |
| `STR_analysis.R` | Analysis of disease-associated short tandem repeat loci across TAD categories. |
| `multiomic_mapping_prioritizedSTRloci.R` | Multiomic integration and locus-level analysis of prioritized short tandem repeat loci. |

---

## 🧬 Figure 1: Hi-C atlas generation and data quality

The `FIG1` directory contains the notebook used to reproduce selected key panels from Figure 1.

| File | Description |
| --- | --- |
| `FIG1_plots.ipynb` | Reproduction of selected Figure 1 panels from deposited supplementary data. |

Relevant upstream analyses include pseudobulk Hi-C preparation and HiCRep concordance analysis.

---

## 🌐 Figure 2: Interaction scaling and three-dimensional genome organization

The `FIG2` directory contains the notebook used to reproduce selected key panels from Figure 2.

| File | Description |
| --- | --- |
| `FIG2_plots.ipynb` | Reproduction of selected Figure 2 panels from deposited supplementary data and Chrom3D-derived outputs. |

Relevant upstream analyses include cis-decay, short-versus-long-range interaction analysis, and Chrom3D spatial analyses.

---

## 🧭 Figure 3: Lifespan subcompartment dynamics

The `FIG3` directory contains the notebook used to reproduce selected key panels from Figure 3.

| File | Description |
| --- | --- |
| `FIG3_plots.ipynb` | Reproduction of selected Figure 3 panels from deposited supplementary data. |

Relevant upstream analyses include CALDER2 subcompartment inference, lifespan subcompartment classification, gene-set enrichment, and integration with cell type- and age group-resolved gene expression.

---

## 🏗️ Figure 4: TAD dynamics, hierarchy, and degree of disorder

The `FIG4` directory contains the notebook used to reproduce selected key panels from Figure 4.

| File | Description |
| --- | --- |
| `FIG4_plots.ipynb` | Reproduction of selected Figure 4 panels from deposited supplementary data. |

Relevant upstream analyses include TimeCompare-based lifespan TAD classification, hierarchical TAD analysis, MDkNN-based degree-of-disorder analysis, and downstream biological-module analyses.

---

## 🧩 Figure 5: Functional constraint and disease-associated repeat loci

The `FIG5` directory contains the notebook used to reproduce selected key panels from Figure 5.

| File | Description |
| --- | --- |
| `FIG5_plots.ipynb` | Reproduction of selected Figure 5 panels from deposited supplementary data. |

Relevant upstream analyses include integration of TAD categories with noncoding constraint, gene-level loss-of-function constraint, disease-associated short tandem repeat loci, and multiomic data.

---

## 🧊 Chrom3D modelling tutorial

A separate tutorial describing the Chrom3D modelling workflow is available in the following repository:

* **Chrom3D tutorial:** [XXX](XXX)

The tutorial repository provides detailed guidance for generating Chrom3D models. The present repository focuses on downstream spatial analyses of the Chrom3D-derived models used in the manuscript.

---

## ▶️ Reproducing manuscript figures

To reproduce selected manuscript plots:

1. Obtain the required supplementary tables, supplementary data, contact matrices, and model outputs from the Synapse repository.
2. Recreate the relevant R and Python software environments using `R_requirements.txt` and `python_requirements.txt`.
3. Run the relevant analysis script(s) from the repository root when upstream analysis outputs are required.
4. Open the corresponding `FIG1`–`FIG5` Jupyter notebook.
5. Follow the notebook instructions to reproduce selected key manuscript panels from the deposited data and analysis outputs.

The figure notebooks are intended to provide transparent and lightweight examples of figure generation. Computationally intensive upstream analyses, including Hi-C matrix processing, temporal TAD analysis, and three-dimensional genome modelling, are kept separate from the figure notebooks and may require additional computing resources.

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
