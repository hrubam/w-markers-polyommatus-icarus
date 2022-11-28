#!/bin/bash
#PBS -l walltime=168:0:0
#PBS -l select=1:ncpus=30:mem=1000gb:scratch_local=3000gb
#PBS -q large_mem@meta-pbs.metacentrum.cz

trap 'clean_scratch' TERM EXIT
DATADIR="/path/to/Canu_Output/"

cp $DATADIR/Correct_5000/file_5000.correctedReads.fasta.gz $SCRATCHDIR
cp $DATADIR/Correct_10000/file_10000.correctedReads.fasta.gz $SCRATCHDIR || exit 1

cd $SCRATCHDIR || exit 2

module add python36-modules-gcc
module add flye-2.8
unpigz -p 29 file_5000.correctedReads.fasta.gz

mkdir Assembly_5000;
flye --nano-raw file_5000.correctedReads.fasta --out-dir Assembly_5000 --genome-size 700m  --meta -t 29 --min-overlap 5000



unpigz -p 29 file_10000.correctedReads.fasta.gz

mkdir Assembly_10000;
flye --nano-raw file_10000.correctedReads.fasta --out-dir Assembly_10000 --genome-size 700m  --meta -t 29 --min-overlap 5000

cp -r Assembly_* /path/to/Flye_Output/ || export CLEAN_SCRATCH=false