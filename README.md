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

Citations:
1. Nielsen, H. (2017). Predicting secretory proteins with SignalP. In Protein function prediction: methods and protocols (pp. 59-73). New York, NY: Springer New York.
2. A. Krogh, B. Larsson, G. von Heijne, and E. L. L. Sonnhammer. Predicting transmembrane protein topology with a hidden Markov model: Application to complete genomes. Journal of Molecular Biology, 305(3):567-580, January 2001.
