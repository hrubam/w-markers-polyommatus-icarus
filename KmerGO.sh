#!/bin/bash
#PBS -l select=1:ncpus=20:mem=500Gb:scratch_local=1000gb
#PBS -l walltime=72:00:00
#PBS -q large_mem@meta-pbs.metacentrum.cz

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky/Trimmed_2"

cp $DATADIR/P_icarus*fastq $SCRATCHDIR || exit 1
cp -r $DATADIR/KmerGO_for_linux_x64_cmd $SCRATCHDIR || exit 1
cp $DATADIR/kmerGo_trait_Pic.csv $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

mkdir input;
mv *.fastq input;

chmod 755 KmerGO_for_linux_x64_cmd/KmerGO_for_cmd;
chmod 755 KmerGO_for_linux_x64_cmd/bin/*;

mkdir kmerGO_55mer_P_icarus;
cd kmerGO_55mer_P_icarus;
../KmerGO_for_linux_x64_cmd/KmerGO_for_cmd -m 0 -k 55 -n 19 -ci 0  -i ../input -t ../kmerGo_trait_Pic.csv;
cd ../

cp -r kmerGO_55mer_P_icarus $DATADIR/Pic_kmers || export CLEAN_SCRATCH=false