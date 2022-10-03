#!/bin/bash
#PBS -l select=1:ncpus=26:mem=700Gb:scratch_local=3000gb
#PBS -l walltime=124:00:00
#PBS -q large_mem@meta-pbs.metacentrum.cz

trap 'clean_scratch' TERM EXIT
DATADIR="/storage/brno2/home/hrubam/Vysledky/"

cp $DATADIR/NanoFilt/Pic_filtered_10000.fastq $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

module add canu-2.1.1

canu -correct -p Pic_10000 -d Correct_10000 genomeSize=700m useGrid=false maxThreads=25 maxMemory=600 -nanopore Pic_filtered_10000.fastq

cp -r Correct_10000 $DATADIR || export CLEAN_SCRATCH=false