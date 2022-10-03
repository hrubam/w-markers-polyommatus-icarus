#!/bin/bash
#PBS -l select=1:ncpus=10:mem=250gb:scratch_local=250gb
#PBS -l walltime=168:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/storage/brno2/home/hrubam/Vysledky"

cp $DATADIR/Slouceno/*.fastq.gz $SCRATCHDIR || exit 1
cp $DATADIR/Truseq_PE.fasta $SCRATCHDIR || exit 2
cd $SCRATCHDIR || exit 3

module add fastQC-0.11.5
module add trimmomatic-0.36
module add trim_galore-0.6.2

#odstranění polyG kontaminace
for c in ./*.fastq.gz;
do
cutadapt --nextseq-trim=20 -o ${c/%.fastq.gz/_cut.fastq.gz} $c;
done

#trimmomatic
for t in ./*F_cut.fastq.gz;
do
java -jar /software/trimmomatic/0.36/dist/jar/trimmomatic-0.36.jar PE -threads 9 -phred33 \
        $t ${t/%F_cut.fastq.gz/R_cut.fastq.gz} \
        ${t/%F_cut.fastq.gz/1_paired.fastq} ${t/%F_cut.fastq.gz/1_unpaired.fastq} ${t/%F_cut.fastq.gz/2_paired.fastq} ${t/%F_cut.fastq.gz/2_unpaired.fastq} \
        ILLUMINACLIP:./Truseq_PE.fasta:2:30:10 CROP:145 HEADCROP:5 MINLEN:50;
done

rm *fastq.gz;

#FASTQC
for f in ./*paired.fastq;
do
fastqc $f
done

cp -r $SCRATCHDIR/*  $DATADIR/Trimmed_2 || export CLEAN_SCRATCH=false