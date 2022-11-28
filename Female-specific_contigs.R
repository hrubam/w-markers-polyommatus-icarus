library (tidyverse) 

setwd("~/path/to/folder/with/output_of_Specific_k-mers_both_sexes.sh")

tab <- read_tsv("./21mer_both_sexes.tsv")

colnames(tab) <- gsub("spec", "21", colnames(tab))

tmp <- read_tsv("./55mer_both_sexes.tsv")
colnames(tmp) <- gsub("spec", "55", colnames(tmp))

tab <- merge(tab, tmp, by=c("contig", "start", "end"))

rm (tmp)

#counting mean
avg <- aggregate(tab[,4:7], by = list(tab$contig), mean, na.rm=TRUE)


avg <- avg %>% mutate(FM21=log2(fem21/male21)) %>% mutate(FM55=log2(fem55/male55))


#counting sum
avg_sum <- aggregate(tab[,4:7], by = list(tab$contig), sum, na.rm=TRUE)
avg_sum <- avg_sum %>% mutate(FM21=log2(fem21/male21)) %>% mutate(FM55=log2(fem55/male55))


#filtering
Wavg <- avg %>% filter(fem21>0 & fem55 > 0 & male21==0 & male55==0)
Femspec_contigs_mean <- avg %>% filter(fem21>0 & fem55 > 0 & male21==0 & male55==0)
Femspec_contigs_sum <- avg_sum %>% filter(fem21>0 & fem55 > 0 & male21==0 & male55==0)
write_tsv(Femspec_contigs_mean, path = "Femspec_contigs_mea.tsv") 
write_tsv(Femspec_contigs_sum, path = "Femspec_contigs_sum.tsv")
