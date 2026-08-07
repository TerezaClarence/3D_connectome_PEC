#!/usr/bin/env Rscript

# ============================================================
# Pairwise Hi-C reproducibility analysis using HiCRep.
#
# Input:
#   Two Juicer .hic files.
#
# Usage:
#   Rscript run_hicrep.R \
#       <hic1> <hic2> \
#       <sample1> <sample2> \
#       <resolution_bp> <output_dir> \
#       [ratio1] [ratio2] [max_distance_bp]
#
# Example:
#   Rscript run_hicrep.R \
#       sample1.hic sample2.hic \
#       sample1 sample2 \
#       100000 results/hicrep
# ============================================================

suppressPackageStartupMessages({
    library(hicrep)
    library(strawr)
})

options(scipen = 20)

# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 6) {
    stop(
        paste(
            "Usage:",
            "Rscript run_hicrep.R",
            "<hic1> <hic2>",
            "<sample1> <sample2>",
            "<resolution_bp> <output_dir>",
            "[ratio1] [ratio2] [max_distance_bp]"
        )
    )
}

hic1 <- args[1]
hic2 <- args[2]

sample1 <- args[3]
sample2 <- args[4]

resolution <- as.integer(args[5])
output_dir <- args[6]

ratio1 <- if (length(args) >= 7) as.numeric(args[7]) else 1
ratio2 <- if (length(args) >= 8) as.numeric(args[8]) else 1

max_distance <- if (length(args) >= 9) {
    as.numeric(args[9])
} else {
    5e6
}

dir.create(
    output_dir,
    recursive = TRUE,
    showWarnings = FALSE
)

stopifnot(file.exists(hic1))
stopifnot(file.exists(hic2))

if (
    ratio1 <= 0 || ratio1 > 1 ||
    ratio2 <= 0 || ratio2 > 1
) {
    stop("Subsampling ratios must be > 0 and <= 1.")
}


# ============================================================
# Helper functions
# ============================================================

read_hic_chromosome <- function(
    hic_file,
    chromosome,
    resolution
) {

    dat <- strawr::straw(
        norm = "NONE",
        fname = hic_file,
        chr1loc = chromosome,
        chr2loc = chromosome,
        unit = "BP",
        binsize = resolution
    )

    if (nrow(dat) == 0) {
        return(
            data.frame(
                st = numeric(),
                ed = numeric(),
                IF = numeric()
            )
        )
    }

    dat <- dat[, 1:3]

    dat[, 1] <- dat[, 1] / resolution + 1
    dat[, 2] <- dat[, 2] / resolution + 1

    colnames(dat) <- c(
        "st",
        "ed",
        "IF"
    )

    dat
}


interaction_to_matrix <- function(
    dat,
    n_bins,
    chromosome,
    resolution
) {

    mat <- matrix(
        0,
        nrow = n_bins,
        ncol = n_bins
    )

    if (nrow(dat) > 0) {

        idx1 <- cbind(
            as.integer(dat$st),
            as.integer(dat$ed)
        )

        idx2 <- cbind(
            as.integer(dat$ed),
            as.integer(dat$st)
        )

        mat[idx1] <- dat$IF
        mat[idx2] <- dat$IF
    }

    coordinates <- data.frame(
        chr = chromosome,
        start = seq(
            0,
            n_bins - 1
        ) * resolution,
        end = seq(
            1,
            n_bins
        ) * resolution
    )

    cbind(
        coordinates,
        mat
    )
}


calculate_scc <- function(
    matrix1,
    matrix2,
    resolution,
    max_distance
) {

    h_hat <- hicrep::htrain(
        matrix1,
        matrix2,
        resolution,
        max_distance,
        0:3
    )

    prepared <- hicrep::prep(
        matrix1,
        matrix2,
        resolution,
        h_hat,
        max_distance
    )

    result <- hicrep::get.scc(
        prepared,
        resolution,
        max_distance
    )

    c(
        scc = result[[3]],
        std = result[[4]]
    )
}


# ============================================================
# Identify chromosomes present in both Hi-C files
# ============================================================

chromosomes1 <- strawr::readHicChroms(hic1)
chromosomes2 <- strawr::readHicChroms(hic2)

common_chromosomes <- intersect(
    chromosomes1$name,
    chromosomes2$name
)

# Exclude chromosome Y by default
common_chromosomes <- setdiff(
    common_chromosomes,
    c("Y", "chrY")
)

if (length(common_chromosomes) == 0) {
    stop("No common chromosomes found between Hi-C files.")
}


# ============================================================
# Run HiCRep chromosome by chromosome
# ============================================================

results <- vector(
    "list",
    length(common_chromosomes)
)

for (i in seq_along(common_chromosomes)) {

    chromosome <- common_chromosomes[i]

    message(
        "Processing ",
        chromosome,
        "..."
    )

    chr_length <- min(
        chromosomes1$length[
            chromosomes1$name == chromosome
        ],
        chromosomes2$length[
            chromosomes2$name == chromosome
        ]
    )

    n_bins <- floor(
        chr_length / resolution
    ) + 1


    # --------------------------------------------------------
    # Read contacts
    # --------------------------------------------------------

    contacts1 <- read_hic_chromosome(
        hic1,
        chromosome,
        resolution
    )

    contacts2 <- read_hic_chromosome(
        hic2,
        chromosome,
        resolution
    )


    matrix1 <- interaction_to_matrix(
        contacts1,
        n_bins,
        chromosome,
        resolution
    )

    matrix2 <- interaction_to_matrix(
        contacts2,
        n_bins,
        chromosome,
        resolution
    )


    depth1 <- sum(
        matrix1[, -(1:3)],
        na.rm = TRUE
    )

    depth2 <- sum(
        matrix2[, -(1:3)],
        na.rm = TRUE
    )


    if (
        depth1 == 0 ||
        depth2 == 0
    ) {

        warning(
            "Skipping ",
            chromosome,
            ": zero interaction depth."
        )

        next
    }


    # ========================================================
    # Standard SCC
    #
    # Preserve the original workflow:
    # depth-adjust only when libraries differ >2-fold.
    # ========================================================

    matrix1_standard <- matrix1
    matrix2_standard <- matrix2

    if (depth1 / depth2 > 2) {

        matrix1_standard <- hicrep::depth.adj(
            matrix1_standard,
            depth2,
            resolution,
            0
        )
    }

    if (depth2 / depth1 > 2) {

        matrix2_standard <- hicrep::depth.adj(
            matrix2_standard,
            depth1,
            resolution,
            0
        )
    }

    standard_scc <- calculate_scc(
        matrix1_standard,
        matrix2_standard,
        resolution,
        max_distance
    )


    # ========================================================
    # User-defined subsampled SCC
    # ========================================================

    matrix1_subsample <- hicrep::depth.adj(
        matrix1,
        floor(depth1 * ratio1),
        resolution,
        0
    )

    matrix2_subsample <- hicrep::depth.adj(
        matrix2,
        floor(depth2 * ratio2),
        resolution,
        0
    )

    subsampled_scc <- calculate_scc(
        matrix1_subsample,
        matrix2_subsample,
        resolution,
        max_distance
    )


    results[[i]] <- data.frame(
        hic1 = sample1,
        hic2 = sample2,
        resolution = resolution,
        chr = chromosome,
        scc = standard_scc["scc"],
        std = standard_scc["std"],
        subsample_scc = subsampled_scc["scc"],
        subsample_std = subsampled_scc["std"]
    )
}


results <- do.call(
    rbind,
    results
)

output_file <- file.path(
    output_dir,
    paste0(
        "hicrep_",
        sample1,
        "_vs_",
        sample2,
        "_",
        resolution,
        "bp.tsv"
    )
)

write.table(
    results,
    output_file,
    sep = "\t",
    quote = FALSE,
    row.names = FALSE
)

message(
    "HiCRep analysis complete: ",
    output_file
)
