#!/bin/bash
#PBS -l select=1:ncpus=26:mem=700Gb:scratch_local=3000gb
#PBS -l walltime=124:00:00
#PBS -q large_mem@meta-pbs.metacentrum.cz

trap 'clean_scratch' TERM EXIT
DATADIR="/path/to/NanoFilt_Output/"

cp $DATADIR/file_filtered_5000.fastq $SCRATCHDIR
cp $DATADIR/file_filtered_10000.fastq $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

module add canu-2.1.1

canu -correct -p file_5000 -d Correct_5000 genomeSize=700m useGrid=false maxThreads=25 maxMemory=600 -nanopore file_filtered_5000.fastq


canu -correct -p file_10000 -d Correct_10000 genomeSize=700m useGrid=false maxThreads=25 maxMemory=600 -nanopore file_filtered_10000.fastq

cp -r Correct_* /path/to/Canu_Output/ || export CLEAN_SCRATCH=false