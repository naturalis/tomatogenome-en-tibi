library(geosphere)
library(ade4)
library(dplyr)

# make a pseudo distance matrix df
hky85.dist <- read.table('../data/HKY85dist.tsv', header = F, sep = "\t" )
labels <- as.character(hky85.dist$V1)         # V1 = accession labels *as factor*
row.names(hky85.dist) <- labels               # assign acc labels as row names
hky85.dist <- dplyr::select( hky85.dist, -V1 ) # remove acc labels column
names(hky85.dist) <- labels                   # assign acc labels as col names

# we have no location for En.Tibi (obviously) so we remove it from Mantel test
hky85.dist <- select(hky85.dist[!rownames(hky85.dist) %in% 'En.Tibi',],-En.Tibi)
labels <- as.character(row.names(hky85.dist))

# filter the accessions to the same taxon set
acc <- read.table('../doc/360/accessions_cleaned.tsv', header = T, sep = "\t")
acc <- dplyr::select( acc, label, longitude, latitude ) # keep label, lat/long
row.names(acc) <- acc$label                             # assign row names
acc <- acc[labels,]                                     # shrink to same set

# populate pairwise great circle distance matrix
acc.dist <- matrix( nrow = length(labels), ncol = length(labels) )
for ( i in 1:(length(labels)-1) ) {
    acc1 <- c( acc[labels[i],'longitude'], acc[labels[i],'latitude'] )
    acc.dist[i,i] <- 0
    for ( j in (i+1):length(labels) ) {
        acc2 <- c( acc[labels[j],'longitude'], acc[labels[j],'latitude'] )
        acc.d <- distHaversine(acc1, acc2)
        acc.dist[i,j] <- acc.d
        acc.dist[j,i] <- acc.d
    }
}

# make data frame just like the HKY85 one
acc.dist <- data.frame(acc.dist)
names(acc.dist) <- labels
row.names(acc.dist) <- labels
rm(i,j,acc1,acc2,acc.d,acc) # cleanup

# convert to dist() objects
hky85.dist <- as.dist(hky85.dist, diag = F, upper = F)
acc.dist <- as.dist(acc.dist, diag = F, upper = F)

# do the test:
mantel.rtest(hky85.dist, acc.dist, nrepet = 9999)
