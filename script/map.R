# Here we plot the localities at which accessions of the 360 tomato project were
# collected. They are _S. lycopersicum_ and other wild relatives. We start by 
# loading the required libraries:

library(maptools)
library(dplyr)
data(wrld_simpl)


# Now we load the data. This is Supplementary Table 1 (Suppl. materials 2) from 
# the paper, converted to TSV. The ID suffixes have the following meaning:
#
# * These accessions were different from their previously taxonomy and changed 
#    according to our data such as fruit weight and population structure 
#    analysis.																	
# # These accessions are modern processing tomato and were used for FST
# + These accessions fruit  were highly segregated in fruit weight

df <- select(read.csv2(
    '../doc/360/ng.3117-S2.tsv', 
    header = T, 
    sep = "\t",
    dec = "."
), Individual_code, Botanical_variety, Categories, Origin, Latitude, Longitude )
df <- df[!is.na(df$Latitude),]
df <- df[df$Longitude<0,]

taxa <- list(
    'red' = 'S. lycopersicum var cerasiforme',
    'gold1' = 'S. pimpinellifolium',
    'chocolate1' = 'S. lycopersicum',
    'darkolivegreen2' = 'S. neorickii',
    'cadetblue2' = 'S. galapagense',
    'cornflowerblue' = 'S. chilense',
    'darkorchid2' = 'S. cheesmaniae'
)

plot(
    wrld_simpl,
    axes = TRUE,
    xlim = c(min(df$Longitude), max(df$Longitude)),
    ylim = c(min(df$Latitude), max(df$Latitude)),
    col = "gray93"
)


# U__0015716
# U__0015717
# WAG0463703

horiloc = 10
for ( color in names(taxa) ) {
    taxon.occurrences <- filter(df, Botanical_variety == taxa[color])
    lon <- select(taxon.occurrences, Longitude)$Longitude
    lat <- select(taxon.occurrences, Latitude)$Latitude
    points(lon, lat, col = 'black', bg = color, pch = 21, cex = 1 )
    horiloc <- horiloc + 30
}

box()
