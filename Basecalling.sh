#!/bin/bash
#PBS -q gpu@meta-pbs.metacentrum.cz
#PBS -l walltime=24:0:0
#PBS -l select=1:ncpus=5:ngpus=1:mem=105gb:scratch_local=1000gb
#PBS -N P.icarus_basecalling
#PBS -l place=exclhost

trap 'clean_scratch' TERM EXIT
cd $SCRATCHDIR || exit 1
cp -r /path/to/folder/with/Minion_output/fast5_for_basecalling/ $SCRATCHDIR || exit 2


module add guppy-4.4.1
mkdir Basecalling_Output
guppy_basecaller \
 -i ./fast5_for_basecalling/ \
 -s ./Basecalling_Output/ \
 -c dna_r10.3_450bps_hac.cfg \
 --compress_fastq \
 -q 0 \
 --qscore_filtering \
 --min_qscore 7 \
 --calib_detect \
 -x "auto" \
 --chunk_size 1000 \
 --num_callers 2 \
 --chunks_per_runner 300 \
 --chunks_per_caller 1000 \
 --gpu_runners_per_device 4

cp -r $SCRATCHDIR/Basecalling_Output/* /path/to/Basecalling_Output/ || exit 3 && export CLEAN_SCRATCH=false
