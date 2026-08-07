#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Run MDkNN / Degree-of-Disorder (DoD) analysis
# over a collection of TAD BED files.
#
# Usage:
#   bash run_mdknn_dod.sh \
#       <cool_matrix> \
#       <tad_directory> \
#       <output_directory> \
#       [mdknn_script] \
#       [k] [ww] [pw]
#
# Example:
#   bash run_mdknn_dod.sh \
#       sample.cool \
#       tads/ \
#       results/DoD/
#
# All *.bed files in the TAD directory will be processed.
# ============================================================

COOL="$1"
TAD_DIR="$2"
OUTPUT_DIR="$3"

MDKNN_SCRIPT="${4:-mdknn.py}"

K="${5:-3}"
WW="${6:-5}"
PW="${7:-2}"

mkdir -p "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}/logs"


# ------------------------------------------------------------
# Sanity checks
# ------------------------------------------------------------

if [[ ! -f "${COOL}" ]]; then
    echo "ERROR: COOL matrix not found: ${COOL}"
    exit 1
fi

if [[ ! -f "${MDKNN_SCRIPT}" ]]; then
    echo "ERROR: MDkNN script not found: ${MDKNN_SCRIPT}"
    exit 1
fi

if [[ ! -d "${TAD_DIR}" ]]; then
    echo "ERROR: TAD directory not found: ${TAD_DIR}"
    exit 1
fi


# ============================================================
# Process BED files
# ============================================================

found_bed=false

for BED in "${TAD_DIR}"/*.bed; do

    [[ -e "${BED}" ]] || continue

    found_bed=true

    if [[ ! -s "${BED}" ]]; then
        echo "Skipping empty BED file: ${BED}"
        continue
    fi

    BASENAME=$(basename "${BED}" .bed)

    OUTPUT_FILE="${OUTPUT_DIR}/${BASENAME}_DoD.txt"
    LOG_FILE="${OUTPUT_DIR}/logs/${BASENAME}_mdknn.log"

    echo "Running MDkNN:"
    echo "  TAD file = ${BED}"
    echo "  output   = ${OUTPUT_FILE}"

    python "${MDKNN_SCRIPT}" \
        -p "${COOL}" \
        -t "${BED}" \
        -O "${OUTPUT_FILE}" \
        -k "${K}" \
        --ww "${WW}" \
        --pw "${PW}"

    if [[ -f "mdknn.log" ]]; then
        mv -f \
            "mdknn.log" \
            "${LOG_FILE}"
    fi

done


if [[ "${found_bed}" == false ]]; then
    echo "ERROR: No BED files found in ${TAD_DIR}"
    exit 1
fi

echo "All MDkNN analyses complete."
