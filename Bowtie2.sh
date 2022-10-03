#!/bin/bash
#PBS -l select=1:ncpus=10:mem=60Gb:scratch_local=500gb
#PBS -l walltime=24:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky/Trimmed_2/Pic_kmers/kmerGO_55mer_P_icarus/kmer_matrix/sex-specific_55mer"

cp ${DATADIR}/femspec_55mer.txt $SCRATCHDIR || exit 1
cp /storage/brno2/home/hrubam/Vysledky/Purge_dups_5000/purged.fa $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

module add bowtie2-2.3.5.1
module add samtools/samtools-1.11-intel-19.0.4-wzth4e4
bowtie2-build -f --threads 9 purged.fa INDEX;
bowtie2 -r --end-to-end -N 0 -L 21 -p 9 --score-min 'L,0,0' -a -x INDEX -U femspec_55mer.txt -S femspec_55mer_bowtie2.sam;
samtools view -Sb -u femspec_55mer_bowtie2.sam | samtools sort -@ 9 -o femspec_55mer_bowtie2.sorted.bam;

module add bedtools-2.26.0
samtools faidx purged.fa; # tohle vyprodukuje file se stejnym nazvem jako genomova fasta jen navic koncovkou .fai budeme dale potrebovat prvni dva sloupce, kde je nazev contigu a jeho delka
cut -f1-2 purged.fa.fai > velikosti_contigu;
bedtools makewindows -g velikosti_contigu -w 2000 > GENOME_SIZE_BED;
bedtools coverage -a GENOME_SIZE_BED -b femspec_55mer_bowtie2.sorted.bam > femspec_55mer.bed;

cp femspec_55mer_bowtie2.sorted.bam $DATADIR || export CLEAN_SCRATCH=false
cp femspec_55mer.bed $DATADIR || export CLEAN_SCRATCH=false