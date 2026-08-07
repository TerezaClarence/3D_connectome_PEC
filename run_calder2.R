#!/usr/bin/env Rscript

# ============================================================
# Run CALDER2 compartment and subcompartment analysis
# from a Juicer .hic file.
#
# Usage:
#   Rscript run_calder2.R \
#       <hic_file> \
#       <output_dir> \
#       [bin_size] \
#       [genome] \
#       [n_cores]
#
# Example:
#   Rscript run_calder2.R \
#       sample.hic \
#       results/CALDER \
#       50000 \
#       hg38 \
#       4
# ============================================================

suppressPackageStartupMessages({
    library(CALDER)
})


# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

args <- commandArgs(
    trailingOnly = TRUE
)

if (length(args) < 2) {
    stop(
        paste(
            "Usage:",
            "Rscript run_calder2.R",
            "<hic_file>",
            "<output_dir>",
            "[bin_size]",
            "[genome]",
            "[n_cores]"
        )
    )
}

hic_file <- args[1]
output_dir <- args[2]

bin_size <- if (length(args) >= 3) {
    as.numeric(args[3])
} else {
    50000
}

genome <- if (length(args) >= 4) {
    args[4]
} else {
    "hg38"
}

n_cores <- if (length(args) >= 5) {
    as.integer(args[5])
} else {
    2
}


# ------------------------------------------------------------
# Settings
# ------------------------------------------------------------

chromosomes <- 1:22

dir.create(
    output_dir,
    recursive = TRUE,
    showWarnings = FALSE
)

if (!file.exists(hic_file)) {
    stop(
        "Input .hic file not found: ",
        hic_file
    )
}


# ============================================================
# Run CALDER2
# ============================================================

CALDER(
    contact_file_hic = hic_file,
    chrs = chromosomes,
    bin_size = bin_size,
    genome = genome,
    save_dir = output_dir,
    save_intermediate_data = TRUE,
    n_cores = n_cores,
    sub_domains = TRUE
)

message(
    "CALDER2 analysis complete."
)
