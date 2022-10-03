#!/bin/bash
#PBS -N purge-dups
#PBS -l select=1:ncpus=16:mem=64gb:scratch_local=250gb
#PBS -l walltime=168:00:00

trap 'clean_scratch' TERM EXIT

cd ${SCRATCHDIR}
cp /storage/brno2/home/hrubam/Vysledky/Correct_5000/Pic_5000.correctedReads.fasta.gz ${SCRATCHDIR}
cp /storage/brno2/home/hrubam/Vysledky/Assembly_5000/assembly.fasta ${SCRATCHDIR}

module add purge-dups-1.0.1

minimap2 -x map-ont assembly.fasta Pic_5000.correctedReads.fasta.gz | gzip -c - > Pic_5000_Purge_dups.paf.gz
pbcstat *paf.gz
calcuts PB.stat > cutoffs 2>calcuts.log
split_fa assembly.fasta > assembly.fasta.split
minimap2 -x asm5 -DP assembly.fasta.split assembly.fasta.split | gzip -c - > assembly.fasta.split.self.paf.gz
purge_dups -2 -T cutoffs -c PB.base.cov assembly.fasta.split.self.paf.gz > dups.bed 2>purge_dups.log
get_seqs dups.bed assembly.fasta
rm ${SCRATCHDIR}/assembly.fasta
rm ${SCRATCHDIR}/Pic_5000.correctedReads.fasta.gz

cp -r ${SCRATCHDIR}/* /storage/brno2/home/hrubam/Vysledky/Purge_dups_5000 || export CLEAN_SCRATCH=false