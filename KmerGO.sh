#!/bin/bash
#PBS -l select=1:ncpus=20:mem=500Gb:scratch_local=1000gb
#PBS -l walltime=72:00:00
#PBS -q large_mem@meta-pbs.metacentrum.cz

trap 'clean_scratch' TERM EXIT

DATADIR="/path/to/FASTQC_Trimmomatic_Trimgalore_Output/"
# copy own data into scratch directory
cp $DATADIR/*fastq $SCRATCHDIR || exit 1
cp -r $DATADIR/KmerGO_for_linux_x64_cmd $SCRATCHDIR || exit 1
# kmerGo_trait.csv = first column: individual id, second column: sex (F/M)
cp $DATADIR/kmerGo_trait.csv $SCRATCHDIR || exit 1
cd $SCRATCHDIR || exit 2

#prepare kmerGo
mkdir input;
mv *.fastq input;

chmod 755 KmerGO_for_linux_x64_cmd/KmerGO_for_cmd;
chmod 755 KmerGO_for_linux_x64_cmd/bin/*;

#running KmerGO for 21-mers
mkdir kmerGO_21-mer;
cd kmerGO_21-mer;
../KmerGO_for_linux_x64_cmd/KmerGO_for_cmd -m 0 -k 21 -n 19 -ci 0  -i ../input -t ../kmerGo_trait.csv;
cd ../

# copy resources from scratch directory back on disk field, if not successful, scratch is not deleted
cp -r kmerGO_21-mer /path/to/KmerGO_Output/ || export CLEAN_SCRATCH=false



#running KmerGO for 55-mers
mkdir kmerGO_55-mer;
cd kmerGO_55-mer;
../KmerGO_for_linux_x64_cmd/KmerGO_for_cmd -m 0 -k 55 -n 19 -ci 0  -i ../input -t ../kmerGo_trait.csv;
cd ../

cp -r kmerGO_55-mer /path/to/KmerGO_Output/ || export CLEAN_SCRATCH=false