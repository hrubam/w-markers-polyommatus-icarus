setwd("~/path/to/K-mers_sample_Output/")

kmer21 <- read_tsv("./21-kmers_sample.txt", col_names = FALSE, skip = 1)

colnames(kmer21) <- c("kmer", paste0("F",1:4), paste0("M",1:6))

kmer21_long <- pivot_longer(kmer21, cols = 2:11, names_to = "sample", values_to = "freq")

ggplot(kmer21_long) + geom_density(aes(freq)) + facet_wrap(~sample)
# change xintercept value to fit your data, it should be between the first big peak (containing k-mers with sequencing errors) and the rest of data
ggplot(kmer21_long) + geom_density(aes(freq)) + facet_wrap(~sample) + xlim(0,0.001) + ylim(0,1000) + geom_vline(xintercept = 0.0001, color = "red")


kmer55 <- read_tsv("./55-kmers_sample.txt", col_names = FALSE, skip = 1)

colnames(kmer55) <- c("kmer", paste0("F",1:4), paste0("M",1:6))

kmer55_long <- pivot_longer(kmer55, cols = 2:11, names_to = "sample", values_to = "freq")

ggplot(kmer55_long) + geom_density(aes(freq)) + facet_wrap(~sample)
# change xintercept value to fit your data, it should be between the first big peak (containing k-mers with sequencing errors) and the rest of data
ggplot(kmer55_long) + geom_density(aes(freq)) + facet_wrap(~sample) + xlim(0,0.001) + ylim(0,1000) + geom_vline(xintercept = 0.0001, color = "red")
