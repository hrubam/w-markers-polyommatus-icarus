#!/bin/bash
#PBS -l select=1:ncpus=17:mem=100gb:scratch_local=250gb
#PBS -l walltime=48:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/path/to/assembly_file"

cp $DATADIR/purged.fa $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2


module add quast-4.6.3

#instead of file.fa use assembly.fasta or purged.fa (depending on which assembly you want to check)
quast.py --min-contig 500 -o Quast_Output -t 16 file.fa

cp -r Quast_Output /path/to/Quast_Output/ || export CLEAN_SCRATCH=false