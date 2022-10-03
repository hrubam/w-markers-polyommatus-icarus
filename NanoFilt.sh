#!/bin/bash
#PBS -l walltime=24:0:0
#PBS -l select=1:ncpus=8:mem=500gb:scratch_local=1000gb

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky/Basecalling_Vysledky/"
cp $DATADIR/Pic_basecalled.fastq.gz $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

unpigz -p 7 Pic_basecalled.fastq.gz

module add python36-modules-gcc

NanoFilt -l 5000 Pic_basecalled.fastq > Pic_filtered_5000.fastq

NanoPlot -t 7 --outdir Pic_filtered_5000_NanoPlot --N50 --format png --fastq $SCRATCHDIR/Pic_filtered_5000.fastq

NanoFilt -l 10000 Pic_basecalled.fastq > Pic_filtered_10000.fastq

NanoPlot -t 7 --outdir Pic_filtered_10000_NanoPlot --N50 --format png --fastq $SCRATCHDIR/Pic_filtered_10000.fastq


cp -r ${SCRATCHDIR}/Pic_f* /storage/brno2/home/hrubam/Vysledky/NanoFilt || export CLEAN_SCRATCH=false