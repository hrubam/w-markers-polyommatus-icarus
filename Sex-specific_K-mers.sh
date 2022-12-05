#!/bin/bash
#PBS -l select=1:ncpus=1:mem=32Gb:scratch_local=250gb
#PBS -l walltime=24:00:00
# cleaning of SCRATCH when error or job termination occur
trap 'clean_scratch' TERM EXIT
DATADIR="/path/to/KmerGO_Output/"

# copy own data into scratch directory
cp $DATADIR/kmerGO_21mer/kmer_matrix/son_matrix_*.txt $SCRATCHDIR || exit 1
cd ${SCRATCHDIR} || exit 2

# 0.0001 = threshold for removing error k-mers, change this value according to the result from the "K-mer_spectrum.R"
for file in son_matrix_*; do awk '{if ($2>0.0001 && $3 > 0.0001 && $4 > 0.0001 && $5 > 0.0001 && $6==0 && $7==0 && $8==0 && $9==0 && $10==0 && $11==0) print $0}' $file >> 21mer_femalespecific.txt; done

for file in son_matrix_*; do awk '{if ($2==0 && $3==0 && $4==0 && $5==0 && $6>0.0001 && $7>0.0001 && $8>0.0001 && $9>0.0001 && $10>0.0001 && $11>0.0001) print $0}' $file >> 21mer_malespecific.txt; done
cp ${SCRATCHDIR}/21mer_*.txt $DATADIR/sex-specific_21mer 
rm ${SCRATCHDIR}/*



cp $DATADIR/kmerGO_55mer/kmer_matrix/son_matrix_*.txt $SCRATCHDIR


# 0.0001 = threshold for removing error k-mers, change this value according to the result from the "K-mer_spectrum.R"
for file in son_matrix_*; do awk '{if ($2>0.0001 && $3 > 0.0001 && $4 > 0.0001 && $5 > 0.0001 && $6==0 && $7==0 && $8==0 && $9==0 && $10==0 && $11==0) print $0}' $file >> 55mer_femalespecific.txt; done

for file in son_matrix_*; do awk '{if ($2==0 && $3==0 && $4==0 && $5==0 && $6>0.0001 && $7>0.0001 && $8>0.0001 && $9>0.0001 && $10>0.0001 && $11>0.0001) print $0}' $file >> 55mer_malespecific.txt; done
cp ${SCRATCHDIR}/55mer_*.txt $DATADIR/sex-specific_55mer || export CLEAN_SCRATCH=false
