#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# TAD calling with HiCExplorer hicFindTADs
#
# This script:
#   1. Computes the TAD separation score once.
#   2. Reuses the separation score to call TADs across
#      combinations of FDR and delta thresholds.
#
# The default parameters below were used for 50-kb Hi-C
# contact matrices.
#
# Usage:
#   bash run_hicfindtads.sh \
#       <matrix.cool> \
#       <output_directory> \
#       [threads]
#
# Example:
#   bash run_hicfindtads.sh \
#       sample_50kb.cool \
#       results/TADs \
#       4
#
# Requirements:
#   HiCExplorer / hicFindTADs
# ============================================================


# ------------------------------------------------------------
# Input arguments
# ------------------------------------------------------------

if [[ $# -lt 2 ]]; then
    echo "Usage:"
    echo "  bash run_hicfindtads.sh <matrix.cool> <output_directory> [threads]"
    exit 1
fi

COOL="$1"
OUTDIR="$2"
NTHREADS="${3:-4}"

mkdir -p "${OUTDIR}"


# ------------------------------------------------------------
# TAD-calling parameters
#
# Defaults correspond to the analysis of 50-kb matrices.
# These values should be adjusted when using a different
# matrix resolution.
# ------------------------------------------------------------

MIN_DEPTH="${MIN_DEPTH:-250000}"
MAX_DEPTH="${MAX_DEPTH:-500000}"
STEP="${STEP:-50000}"

MIN_BOUNDARY_DIST="${MIN_BOUNDARY_DIST:-200000}"


# ------------------------------------------------------------
# Parameter sweep
#
# thresholdComparisons is interpreted as an FDR threshold
# because --correctForMultipleTesting fdr is used.
# ------------------------------------------------------------

Q_LIST="${Q_LIST:-0.05 0.01 0.005}"

DELTA_LIST="${DELTA_LIST:-0.01 0.015 0.02 0.025 0.03}"


# ------------------------------------------------------------
# Sanity checks
# ------------------------------------------------------------

if ! command -v hicFindTADs >/dev/null 2>&1; then
    echo "ERROR: hicFindTADs was not found in PATH."
    exit 1
fi

if [[ ! -f "${COOL}" ]]; then
    echo "ERROR: Input matrix not found: ${COOL}"
    exit 1
fi


echo "------------------------------------------------------------"
echo "TAD calling with hicFindTADs"
echo "------------------------------------------------------------"
echo "Input matrix:             ${COOL}"
echo "Output directory:         ${OUTDIR}"
echo "Threads:                  ${NTHREADS}"
echo "Minimum depth:            ${MIN_DEPTH}"
echo "Maximum depth:            ${MAX_DEPTH}"
echo "Step:                     ${STEP}"
echo "Minimum boundary distance:${MIN_BOUNDARY_DIST}"
echo "FDR thresholds:           ${Q_LIST}"
echo "Delta thresholds:         ${DELTA_LIST}"
echo "------------------------------------------------------------"


# ============================================================
# 1. Calculate TAD separation scores
#
# The computationally intensive separation-score calculation
# is performed once and reused for subsequent parameter
# combinations.
# ============================================================

SEP_PREFIX="${OUTDIR}/TAD_separation"

SEP_SCORE="${SEP_PREFIX}_tad_score.bm"


if [[ ! -s "${SEP_SCORE}" ]]; then

    echo ""
    echo "[RUN] Computing TAD separation scores..."

    hicFindTADs \
        --matrix "${COOL}" \
        --outPrefix "${SEP_PREFIX}" \
        --minDepth "${MIN_DEPTH}" \
        --maxDepth "${MAX_DEPTH}" \
        --step "${STEP}" \
        --minBoundaryDistance "${MIN_BOUNDARY_DIST}" \
        --thresholdComparisons 0.05 \
        --delta 0.01 \
        --correctForMultipleTesting fdr \
        -p "${NTHREADS}"

else

    echo ""
    echo "[SKIP] Existing separation score found:"
    echo "       ${SEP_SCORE}"

fi


# ============================================================
# 2. TAD parameter sweep
#
# Reuse the separation-score calculation while varying:
#
#   - FDR threshold
#   - delta threshold
#
# Each parameter combination generates an independent TAD
# call.
# ============================================================

for Q_VALUE in ${Q_LIST}; do

    for DELTA in ${DELTA_LIST}; do

        OUT_PREFIX="${OUTDIR}/TAD_q${Q_VALUE}_delta${DELTA}"

        DOMAIN_FILE="${OUT_PREFIX}_domains.bed"


        # Skip previously completed combinations
        if [[ -s "${DOMAIN_FILE}" ]]; then

            echo ""
            echo "[SKIP] Existing TAD calls:"
            echo "       ${DOMAIN_FILE}"

            continue
        fi


        echo ""
        echo "[RUN] FDR=${Q_VALUE}, delta=${DELTA}"


        hicFindTADs \
            --matrix "${COOL}" \
            --outPrefix "${OUT_PREFIX}" \
            --TAD_sep_score_prefix "${SEP_PREFIX}" \
            --minBoundaryDistance "${MIN_BOUNDARY_DIST}" \
            --thresholdComparisons "${Q_VALUE}" \
            --delta "${DELTA}" \
            --correctForMultipleTesting fdr \
            -p "${NTHREADS}"

    done

done


echo ""
echo "------------------------------------------------------------"
echo "TAD calling complete."
echo "Results written to:"
echo "  ${OUTDIR}"
echo "------------------------------------------------------------"
