#!/bin/bash
#PBS -l select=1:ncpus=10:mem=60Gb:scratch_local=500gb
#PBS -l walltime=168:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky/Assembly_10000"

cp ${DATADIR}/assembly.fasta $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

module add conda-modules-py37

conda activate busco

module add augustus-3.3.2
module add blast+-2.10.0
module add augustus-3.3.1

mkdir $SCRATCHDIR/augustus_configs
cp -r $AUGUSTUS_CONFIG_PATH/* $SCRATCHDIR/augustus_configs/
export AUGUSTUS_CONFIG_PATH=$SCRATCHDIR/augustus_configs
busco -c 9  -i *.fasta -o BUSCO_5_Assembly_10000.out -l lepidoptera -m genome --augustus
busco -c 9  -i *.fasta -o BUSCO_5_Assembly_10000.out -l insecta -m genome --augustus

cp -r BUSCO_5_Assembly_10000.out $DATADIR || export CLEAN_SCRATCH=false