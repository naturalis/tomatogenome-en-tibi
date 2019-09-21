library(dplyr)
library(ggplot2)

# see https://stackoverflow.com/questions/33643181/how-do-i-flip-rows-and-columns-in-r
df <- read.csv2('../data/snp_matrix.tsv', header = T, sep = "\t")
df2 <- data.frame(t(df[-1]))
colnames(df2) <- df[, 1]
df2 <- df2[ , apply(df2, 2, var) != 0]

# see https://www.youtube.com/watch?v=dyy0nWOqKHI
pca1 <- prcomp(df2, scale. = T)
pca1_loading <- pca1$x
pca1_loading <- data.frame(pca1_loading)
pca1_loading$Individual_code <- row.names(pca1_loading)

# join with accession metadata
accessions <- read.csv2('../doc/360/accessions_cleaned.tsv', header = T, sep = "\t")
row.names(accessions) <- accessions$Individual_code
pca1_loading <- inner_join(pca1_loading, accessions, by = "Individual_code")

# plot
ggplot(pca1_loading, aes(x=PC1,y=PC2,color=Botanical_variety))+
    geom_point(alpha=0.5) +
    labs(x = "PC1", y = "PC2")+
    theme_classic()+
    scale_color_brewer(palette="Set1")+
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold"))
dev.off()    
