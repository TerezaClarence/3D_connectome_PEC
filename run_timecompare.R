#!/usr/bin/env Rscript

# ============================================================
# Run temporal TAD analysis using TADCompare::TimeCompare.
#
# Input:
#   A manifest describing contact matrices and optional
#   replicate/time-point groupings.
#
# Manifest columns:
#   sample
#   group
#   matrix_file
#
# Each matrix_file should contain a sparse three-column
# intrachromosomal contact matrix:
#
#   bin1    bin2    contacts
#
# Usage:
#   Rscript run_timecompare.R \
#       <manifest.tsv> \
#       <resolution_bp> \
#       <output_prefix> \
#       <output_dir> \
#       [z_thresh] \
#       [window_size] \
#       [gap_thresh]
# ============================================================

suppressPackageStartupMessages({
    library(data.table)
    library(TADCompare)
    library(ggplot2)
})


# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

args <- commandArgs(
    trailingOnly = TRUE
)

if (length(args) < 4) {

    stop(
        paste(
            "Usage:",
            "Rscript run_timecompare.R",
            "<manifest.tsv>",
            "<resolution_bp>",
            "<output_prefix>",
            "<output_dir>",
            "[z_thresh]",
            "[window_size]",
            "[gap_thresh]"
        )
    )
}

manifest_file <- args[1]
resolution <- as.integer(args[2])
output_prefix <- args[3]
output_dir <- args[4]

z_thresh <- if (length(args) >= 5) {
    as.numeric(args[5])
} else {
    2
}

window_size <- if (length(args) >= 6) {
    as.integer(args[6])
} else {
    15
}

gap_thresh <- if (length(args) >= 7) {
    as.numeric(args[7])
} else {
    0.2
}


dir.create(
    output_dir,
    recursive = TRUE,
    showWarnings = FALSE
)


# ============================================================
# Read manifest
# ============================================================

manifest <- data.table::fread(
    manifest_file
)

required_columns <- c(
    "sample",
    "matrix_file"
)

missing_columns <- setdiff(
    required_columns,
    colnames(manifest)
)

if (length(missing_columns) > 0) {

    stop(
        "Manifest is missing required columns: ",
        paste(
            missing_columns,
            collapse = ", "
        )
    )
}


# ============================================================
# Read contact matrices
# ============================================================

contact_matrices <- lapply(
    manifest$matrix_file,
    function(file) {

        if (!file.exists(file)) {
            stop(
                "Contact matrix not found: ",
                file
            )
        }

        mat <- data.table::fread(
            file,
            header = FALSE
        )

        if (ncol(mat) < 3) {
            stop(
                "Contact matrix must contain at least ",
                "three columns: ",
                file
            )
        }

        mat <- mat[, 1:3]

        colnames(mat) <- c(
            "region1",
            "region2",
            "IF"
        )

        as.data.frame(mat)
    }
)

names(contact_matrices) <- manifest$sample


# ============================================================
# Replicate/time-point groupings
# ============================================================

if ("group" %in% colnames(manifest)) {

    groupings <- as.character(
        manifest$group
    )

} else {

    groupings <- NULL
}


# ============================================================
# Run TimeCompare
# ============================================================

timecompare_results <- TADCompare::TimeCompare(
    cont_mats = contact_matrices,
    resolution = resolution,
    z_thresh = z_thresh,
    window_size = window_size,
    gap_thresh = gap_thresh,
    groupings = groupings
)


# ============================================================
# Save outputs
# ============================================================

write.table(
    timecompare_results$TAD_Bounds,
    file = file.path(
        output_dir,
        paste0(
            output_prefix,
            "_TAD_boundaries.tsv"
        )
    ),
    sep = "\t",
    quote = FALSE,
    row.names = FALSE
)

write.table(
    timecompare_results$All_Bounds,
    file = file.path(
        output_dir,
        paste0(
            output_prefix,
            "_all_boundary_scores.tsv"
        )
    ),
    sep = "\t",
    quote = FALSE,
    row.names = FALSE
)

ggplot2::ggsave(
    filename = file.path(
        output_dir,
        paste0(
            output_prefix,
            "_boundary_categories.pdf"
        )
    ),
    plot = timecompare_results$Count_Plot,
    width = 7,
    height = 5
)

saveRDS(
    timecompare_results,
    file = file.path(
        output_dir,
        paste0(
            output_prefix,
            "_TimeCompare.rds"
        )
    )
)

message(
    "TimeCompare analysis complete."
)
