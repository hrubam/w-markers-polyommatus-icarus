#!/bin/bash
#PBS -l select=1:ncpus=10:mem=60Gb:scratch_local=500gb
#PBS -l walltime=24:00:00

trap 'clean_scratch' TERM EXIT

INPUT="/path/to/sex-specific k-mers.txt"

#this script was used for female-specific and male-specific 21-mers and 55-mers

cp ${INPUT} $SCRATCHDIR || exit 1
cp ASSEMBLY_FILE.fa $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

module add bowtie2-2.3.5.1
module add samtools/samtools-1.11-intel-19.0.4-wzth4e4
bowtie2-build -f --threads 9 purged.fa INDEX;
#-L = length of alignment without mismatch (length of k-mer for mapping with 100% homology) 
bowtie2 -r --end-to-end -N 0 -L 21 -p 9 --score-min 'L,0,0' -a -x INDEX -U ${INPUT} -S OUTPUT.sam;
samtools view -Sb -u OUTPUT.sam | samtools sort -@ 9 -o OUTPUT.sorted.bam;

module add bedtools-2.26.0
samtools faidx purged.fa; 
cut -f1-2 ASSEMBLY_FILE.fa.fai > contig_size;
bedtools makewindows -g contig_size -w 2000 > GENOME_SIZE_BED;
bedtools coverage -a GENOME_SIZE_BED -b OUTPUT.sorted.bam > OUTPUT.bed;

cp OUTPUT.bed $DATADIR || export CLEAN_SCRATCH=false