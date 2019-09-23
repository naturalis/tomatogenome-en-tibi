library(dplyr)
library(ggplot2)
library(plotly)
library(Rtsne)

# load accessions
accessions <- read.csv2('../doc/360/accessions_cleaned.tsv', header = T, sep = "\t")
#accessions <- filter(accessions, grepl('S. lycopersicum|Unknown', botanical_variety))
row.names(accessions) <- accessions$label

# see https://stackoverflow.com/questions/33643181/how-do-i-flip-rows-and-columns-in-r
df <- read.csv2('../data/snp_matrix.tsv', header = T, sep = "\t")
df <- df[as.character(accessions$label)] # only keep filtered accessions

# subsample SNP rows
numTrain <- 15000
set.seed(1)
rows <- sample(1:nrow(df), numTrain)
df <- df[rows,]

# transpose
df2 <- data.frame(t(df))
df2 <- df2[ , apply(df2, 2, var) != 0]
row.names(df2) <- as.character(accessions$label)

# T-distributed Stochastic Neighbor Embedding
res <- Rtsne(df2, 
             num_threads=4, 
             dims=2, 
             perplexity=26, 
             verbose=T, 
             max_iter=4000,
             partial_pca=T,
             theta=0.4
)
plot(res$Y, asp=1)
colors = rainbow(length(unique(accessions$botanical_variety)))
names(colors) = unique(accessions$botanical_variety)
text(res$Y, 
     labels=accessions$label, 
     col=colors[accessions$botanical_variety],
     cex=0.5)

# cluster
d <- dist(df2, method = "euclidean")
fit <- hclust(d, method="ward")
fit$labels <- accessions[fit$labels,]$country
plot(fit)
