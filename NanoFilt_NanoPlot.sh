#!/bin/bash
#PBS -l walltime=24:0:0
#PBS -l select=1:ncpus=8:mem=500gb:scratch_local=1000gb

trap 'clean_scratch' TERM EXIT

DATADIR="/path/to/Basecalling_Output/"
cp $DATADIR/file_basecalled.fastq.gz $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

unpigz -p 7 file_basecalled.fastq.gz

module add python36-modules-gcc

NanoFilt -l 5000 file_basecalled.fastq > file_filtered_5000.fastq

NanoPlot -t 7 --outdir file_filtered_5000_NanoPlot --N50 --format png --fastq $SCRATCHDIR/file_filtered_5000.fastq

NanoFilt -l 10000 file_basecalled.fastq > file_filtered_10000.fastq

NanoPlot -t 7 --outdir file_filtered_10000_NanoPlot --N50 --format png --fastq $SCRATCHDIR/file_filtered_10000.fastq


cp -r ${SCRATCHDIR}/file_f* /path/to/output/folder || export CLEAN_SCRATCH=false