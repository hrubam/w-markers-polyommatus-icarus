#!/bin/bash
#PBS -N purge-dups
#PBS -l select=1:ncpus=16:mem=64gb:scratch_local=250gb
#PBS -l walltime=168:00:00

trap 'clean_scratch' TERM EXIT

cd ${SCRATCHDIR}
cp /path/to/Canu_Output/Correct_5000/file_5000.correctedReads.fasta.gz ${SCRATCHDIR}
cp /path/to/Flye_Output/Assembly_5000/assembly.fasta ${SCRATCHDIR}

module add purge-dups-1.0.1

minimap2 -x map-ont assembly.fasta file_5000.correctedReads.fasta.gz | gzip -c - > file_5000_Purge_dups.paf.gz
pbcstat *paf.gz
calcuts PB.stat > cutoffs 2>calcuts.log
split_fa assembly.fasta > assembly.fasta.split
minimap2 -x asm5 -DP assembly.fasta.split assembly.fasta.split | gzip -c - > assembly.fasta.split.self.paf.gz
purge_dups -2 -T cutoffs -c PB.base.cov assembly.fasta.split.self.paf.gz > dups.bed 2>purge_dups.log
get_seqs dups.bed assembly.fasta
rm ${SCRATCHDIR}/assembly.fasta
rm ${SCRATCHDIR}/file_5000.correctedReads.fasta.gz

cp -r ${SCRATCHDIR}/* /path/to/PurgeDups_Output/Purge_dups_5000

trap 'clean_scratch' TERM EXIT

cd ${SCRATCHDIR}
cp /path/to/Canu_Output/Correct_10000/file_10000.correctedReads.fasta.gz ${SCRATCHDIR}
cp /path/to/Flye_Output/Assembly_10000/assembly.fasta ${SCRATCHDIR}

module add purge-dups-1.0.1

minimap2 -x map-ont assembly.fasta Pic_10000.correctedReads.fasta.gz | gzip -c - > file_10000_Purge_dups.paf.gz
pbcstat *paf.gz
calcuts PB.stat > cutoffs 2>calcuts.log
split_fa assembly.fasta > assembly.fasta.split
minimap2 -x asm5 -DP assembly.fasta.split assembly.fasta.split | gzip -c - > assembly.fasta.split.self.paf.gz
purge_dups -2 -T cutoffs -c PB.base.cov assembly.fasta.split.self.paf.gz > dups.bed 2>purge_dups.log
get_seqs dups.bed assembly.fasta
rm ${SCRATCHDIR}/assembly.fasta
rm ${SCRATCHDIR}/file_10000.correctedReads.fasta.gz

cp -r ${SCRATCHDIR}/* /path/to/PurgeDups_Output/Purge_dups_10000 || export CLEAN_SCRATCH=false