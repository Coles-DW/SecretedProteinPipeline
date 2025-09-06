#!/bin/bash
# =============================================================================
# SignalP + TMHMM pipeline for identifying secreted proteins in FASTA files
# Author: Donovin Coles
# Date: 2025-09-01
# =============================================================================

# --- CONFIGURATION ---
WORKDIR=""
FASTA_FILE="$WORKDIR/All_Unigene.fa.transdecoder.pep"
SIGNALP_DIR="$WORKDIR/signalp-4.1"
TMHMM_DIR="$WORKDIR/tmhmm-2.0c"
TMPDIR="$WORKDIR/tmp"

mkdir -p "$TMPDIR"

# --- STEP 1: Run SignalP 4.1 ---
echo "[INFO] Running SignalP 4.1..."
perl "$SIGNALP_DIR/signalp" -f short -t euk "$FASTA_FILE" > "$WORKDIR/All_Unigene_signalp4.1_short.txt"

# --- STEP 2: Extract protein IDs with predicted signal peptide ---
echo "[INFO] Extracting SignalP-positive protein IDs..."
awk 'NR>1 && $0 !~ /^#/ {print $1}' "$WORKDIR/All_Unigene_signalp4.1_short.txt" > "$WORKDIR/proteins_with_SP_IDs.txt"

# --- STEP 3: Prepare simplified FASTA with only SignalP-positive proteins ---
echo "[INFO] Extracting sequences of SignalP-positive proteins..."
awk 'NR==FNR {ids[$1]; next} /^>/ {h=$1; sub(/^>/,"",h); keep=(h in ids)} keep {print}' \
    "$WORKDIR/proteins_with_SP_IDs.txt" "$FASTA_FILE" > "$WORKDIR/secreted_proteins.fa"

# --- STEP 4: Run TMHMM on the SignalP-positive sequences ---
echo "[INFO] Running TMHMM..."
export TMHMM="$TMHMM_DIR"
export TMPDIR="$TMPDIR"
perl "$TMHMM_DIR/bin/tmhmm" "$WORKDIR/secreted_proteins.fa" > "$WORKDIR/TMHMMresult.txt"

# --- STEP 5: Filter for proteins with no predicted transmembrane helices ---
echo "[INFO] Extracting proteins with zero TMHs..."
awk '{if($5==0) print $1}' "$WORKDIR/TMHMMresult.txt" > "$WORKDIR/proteins_no_TM_IDs.txt"

# --- STEP 6: Extract sequences of secreted proteins with no TMHs ---
echo "[INFO] Extracting final secreted protein sequences..."
awk 'NR==FNR {ids[$1]; next} /^>/ {h=$1; sub(/^>/,"",h); keep=(h in ids)} keep {print}' \
    "$WORKDIR/proteins_no_TM_IDs.txt" "$WORKDIR/secreted_proteins.fa" > "$WORKDIR/secreted_proteins_final.fa"

# --- STEP 7: Optional: filter for small secreted proteins (<=300 aa) ---
echo "[INFO] Extracting small secreted proteins (<=300 aa)..."
awk '
BEGIN {RS=">"; ORS=""}
NR>1 {
    split($0, lines, "\n")
    header = lines[1]
    seq = ""
    for(i=2;i<=length(lines);i++){seq=seq lines[i]}
    if(length(seq) <= 300){print ">" header "\n" seq "\n"}
}' "$WORKDIR/secreted_proteins_final.fa" > "$WORKDIR/secreted_small_proteins.fa"

# --- STEP 8: Generate list of small secreted protein IDs ---
awk '/^>/ {sub(/^>/,""); print}' "$WORKDIR/secreted_small_proteins.fa" > "$WORKDIR/secreted_small_proteins_IDs.txt"

echo "[INFO] Pipeline complete!"
echo "Total secreted proteins (no TMH): $(wc -l < "$WORKDIR/proteins_no_TM_IDs.txt")"
echo "Total small secreted proteins (<=300 aa): $(wc -l < "$WORKDIR/secreted_small_proteins_IDs.txt")"

Citations:
1. Nielsen, H. (2017). Predicting secretory proteins with SignalP. In Protein function prediction: methods and protocols (pp. 59-73). New York, NY: Springer New York.
2. A. Krogh, B. Larsson, G. von Heijne, and E. L. L. Sonnhammer. Predicting transmembrane protein topology with a hidden Markov model: Application to complete genomes. Journal of Molecular Biology, 305(3):567-580, January 2001.
