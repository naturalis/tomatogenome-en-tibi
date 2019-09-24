library(dplyr)
library(ggplot2)
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
             #perplexity=12,
             verbose=T, 
             max_iter=1500,
             theta=0.5
)
results <- data.frame( 
    x = res$Y[,1], 
    y = res$Y[,2], 
    botanical_variety = accessions$botanical_variety,
    label = accessions$label)
ggplot( results, aes( x = x, y = y ) ) + 
    geom_point( 
        shape = 21, 
        aes( bg = results$botanical_variety ), 
        size = 2,
        position = position_jitter( width = 0.1,height = 0.1 ) ) +
    scale_fill_brewer(palette="Accent") +
    labs( 
        bg="Botanical variety", 
        title = "t-SNE of landraces, cultivars and wild tomatoes"
    )