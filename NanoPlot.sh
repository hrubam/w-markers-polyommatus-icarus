#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=8:mem=32gb:scratch_local=500gb
#PBS -N NanoPlot
#PBS -o /storage/brno2/home/hrubam/Vysledky/NanoStat/
#PBS -e /storage/brno2/home/hrubam/Vysledky/NanoStat/

trap 'clean_scratch' TERM EXIT
cd $SCRATCHDIR || exit 1

cp /storage/brno2/home/hrubam/Vysledky/Basecalling_Vysledky/Pic_basecalled.fastq.gz $SCRATCHDIR/ || exit 2
cd $SCRATCHDIR

gunzip $SCRATCHDIR/Pic_basecalled.fastq.gz

module load python36-modules-gcc

NanoPlot -t 7 --outdir $SCRATCHDIR/ --prefix Pic_basecalled --N50 --format png --fastq $SCRATCHDIR/Pic_basecalled.fastq


cp -r ${SCRATCHDIR}/* /storage/brno2/home/hrubam/Vysledky/NanoStat/ || CLEAN_SCRATCH=false
