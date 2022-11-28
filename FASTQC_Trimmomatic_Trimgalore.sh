#!/bin/bash
#PBS -l select=1:ncpus=10:mem=250gb:scratch_local=250gb
#PBS -l walltime=168:00:00

trap 'clean_scratch' TERM EXIT

DATADIR="/path/to/all_files.fastq.gz"

cp $DATADIR $SCRATCHDIR || exit 1
cp $path/to/file_with_Illumina_adaptors.fasta $SCRATCHDIR || exit 2
cd $SCRATCHDIR || exit 3

module add fastQC-0.11.5
module add trimmomatic-0.36
module add trim_galore-0.6.2

#removing polyG contamination
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
        ILLUMINACLIP:./file_with_Illumina_adaptors.fasta:2:30:10 CROP:145 HEADCROP:5 MINLEN:50;
done

rm *fastq.gz;

#FASTQC
for f in ./*paired.fastq;
do
fastqc $f
done

cp -r $SCRATCHDIR/*  /path/to/FASTQC_Trimmomatic_Trimgalore_Output/ || export CLEAN_SCRATCH=false