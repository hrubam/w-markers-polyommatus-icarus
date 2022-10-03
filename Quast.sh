#!/bin/bash
#PBS -l select=1:ncpus=17:mem=100gb:scratch_local=250gb
#PBS -l walltime=48:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky/Purge_dups_5000"

cp $DATADIR/purged.fa $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2


module add quast-4.6.3
quast.py --min-contig 500 -o Quast_5000_purged -t 16 purged.fa

cp -r Quast_5000_purged $DATADIR || export CLEAN_SCRATCH=false