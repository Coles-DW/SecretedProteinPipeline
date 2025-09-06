# Secreted Protein Prediction Pipeline

This repository provides a reproducible pipeline to predict secreted proteins and small secreted proteins (≤300 aa) from protein FASTA sequences using **SignalP 4.1** and **TMHMM 2.0c**.

---

## Requirements

- Linux environment (tested on older Linux cluster)
- Perl (>=5.10)
- SignalP 4.1 installed in `signalp-4.1/`
- TMHMM 2.0c installed in `tmhmm-2.0c/`
- Input protein FASTA file (e.g., `All_Unigene.fa.transdecoder.pep`)

---

## How to Run

1. Make the main script executable:

```bash
chmod +x bin/run_secreted_pipeline.sh
