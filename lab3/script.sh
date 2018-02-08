#! /usr/bin/env bash
# Auth: Jennifer Chang

DIR=../data
# ===== Alignment
mafft --auto ${DIR}/cob_nt.fasta > cob_nt_aln.fa
