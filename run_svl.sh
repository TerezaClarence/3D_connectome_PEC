#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Calculate short-to-long range contact ratios using HiCExplorer
# hicPlotSVL
#
# Usage:
#   bash run_svl.sh <matrix> <resolution_bp> <output_dir> [threads]
#
# Example:
#   bash run_svl.sh sample_40kb.h5 40000 results/SVL 4
# ============================================================

MATRIX="$1"
RESOLUTION="$2"
OUTPUT_DIR="$3"
THREADS="${4:-4}"

# Maximum genomic distances to evaluate
DISTANCES=(1000000 2000000)

mkdir -p "${OUTPUT_DIR}"

if [[ ! -f "${MATRIX}" ]]; then
    echo "ERROR: Matrix not found: ${MATRIX}"
    exit 1
fi

for DISTANCE in "${DISTANCES[@]}"; do

    DISTANCE_MB=$((DISTANCE / 1000000))
    RESOLUTION_KB=$((RESOLUTION / 1000))

    echo "Running SVL:"
    echo "  matrix     = ${MATRIX}"
    echo "  resolution = ${RESOLUTION_KB} kb"
    echo "  distance   = ${DISTANCE_MB} Mb"

    hicPlotSVL \
        -m "${MATRIX}" \
        --distance "${DISTANCE}" \
        --threads "${THREADS}" \
        --plotFileName "${OUTPUT_DIR}/SVL_${RESOLUTION_KB}kb_${DISTANCE_MB}Mb.png" \
        --outFileName "${OUTPUT_DIR}/SVL_pvalues_${RESOLUTION_KB}kb_${DISTANCE_MB}Mb.txt" \
        --outFileNameData "${OUTPUT_DIR}/SVL_rawData_${RESOLUTION_KB}kb_${DISTANCE_MB}Mb.txt"

done

echo "SVL analysis complete."
