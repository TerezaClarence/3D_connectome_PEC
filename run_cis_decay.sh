#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Calculate contact probability as a function of genomic
# distance using HiCExplorer hicPlotDistVsCounts.
#
# Usage:
#   bash run_cis_decay.sh <matrix> <output_prefix> <output_dir> \
#        [max_distance_bp] [excluded_chromosomes]
#
# Example:
#   bash run_cis_decay.sh sample.cool sample results/cis_decay \
#        3000000 "M,X,Y"
# ============================================================

MATRIX="$1"
OUTPUT_PREFIX="$2"
OUTPUT_DIR="$3"

MAX_DISTANCE="${4:-3000000}"
EXCLUDED_CHROMOSOMES="${5:-M,X,Y}"

mkdir -p "${OUTPUT_DIR}"

if [[ ! -f "${MATRIX}" ]]; then
    echo "ERROR: Matrix not found: ${MATRIX}"
    exit 1
fi

# Convert comma-separated chromosome names into an array
IFS=',' read -ra EXCLUDE_ARRAY <<< "${EXCLUDED_CHROMOSOMES}"

echo "Running cis-decay analysis:"
echo "  matrix       = ${MATRIX}"
echo "  max distance = ${MAX_DISTANCE} bp"
echo "  exclude      = ${EXCLUDE_ARRAY[*]}"

hicPlotDistVsCounts \
    -m "${MATRIX}" \
    -o "${OUTPUT_DIR}/${OUTPUT_PREFIX}_cis_decay.png" \
    --outFileData "${OUTPUT_DIR}/${OUTPUT_PREFIX}_cis_decay.txt" \
    --maxdepth "${MAX_DISTANCE}" \
    --chromosomeExclude "${EXCLUDE_ARRAY[@]}" \
    --plotsize 5 4.2

echo "Cis-decay analysis complete."
