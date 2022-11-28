#use this to create one table for 21-mer and one for 55-mer
#BED files are outputs of Bowtie2.sh script

echo -e "contig\tstart\tend\tfemalespecific" > 21mer_both_sexes.tsv 
cut -f1-4 femalespecific-21mer.bed >> 21mer_both_sexes.tsv
echo „malespecific“ > tmp
cut -f4 malespecific_21mer.bed >> tmp
paste 21mer_both_sexes.tsv tmp > tmp2
mv tmp2 21mer_both_sexes.tsv
rm tmp
