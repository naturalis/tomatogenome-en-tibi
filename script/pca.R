library(dplyr)
library(ggplot2)
library(plotly)
library(M3C)
library(Rtsne)

# load accessions
accessions <- read.csv2('../doc/360/accessions_cleaned.tsv', header = T, sep = "\t")
accessions <- filter(accessions, grepl('S. lycopersicum|Unknown', botanical_variety))
row.names(accessions) <- accessions$label

# see https://stackoverflow.com/questions/33643181/how-do-i-flip-rows-and-columns-in-r
df <- read.csv2('../data/snp_matrix.tsv', header = T, sep = "\t")
df <- df[as.character(accessions$label)]
df2 <- data.frame(t(df))
df2 <- df2[ , apply(df2, 2, var) != 0]
row.names(df2) <- as.character(accessions$label)

# TODO: solve memory problem
# TODO
res <- Rtsne(df2)
plot(res$Y,col=df2$country, asp=1)

# see https://www.youtube.com/watch?v=dyy0nWOqKHI
pca1 <- prcomp(df2, scale. = T)
pca1_loading <- pca1$x
pca1_loading <- data.frame(pca1_loading)
pca1_loading$label <- row.names(pca1_loading)

# join with accession metadata
pca1_loading <- inner_join(pca1_loading, accessions, by = "label")

# plot
ggplot(pca1_loading, aes(x=PC1,y=PC2,color=country))+
    geom_point(alpha=0.5, size=1) +
    labs(x = "PC1", y = "PC2")+
    theme_classic()+
    scale_color_brewer(palette="Set1")+
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold"))
dev.off()    

# plot 3d
plot_ly(
    x=pca1_loading$PC1, 
    y=pca1_loading$PC2, 
    z=pca1_loading$PC3, 
    type="scatter3d", 
    mode="markers", 
    color=pca1_loading$country)

# cluster
d <- dist(df2, method = "euclidean")
fit <- hclust(d, method="ward")
fit$labels <- accessions[fit$labels,]$country
plot(fit)