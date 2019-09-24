# Here we plot the localities at which accessions of the 360 tomato project were
# collected. They are _S. lycopersicum_ and other wild relatives. We start by 
# loading the required libraries:

library(dplyr)
library(ggplot2)
library(ggmap)
library(RColorBrewer)

# supplementary table S2 from the 360 tomato paper
df <- select(read.csv2(
    '../doc/360/accessions_cleaned.tsv', 
    header = T, 
    sep = "\t",
    dec = "."
), label, botanical_variety, status, country, latitude, longitude )

# remove non-georeferenced accessions
df <- df[!is.na(df$latitude),]

# only look at the western hemisphere 
# (otherwise there is one accession in the Philippines)
df <- df[df$longitude<0,]

# make the bounding box relative to the extent of the occurrences
bbox <- make_bbox(lon = df$longitude, lat = df$latitude, f = .05)

# fetch a mp from google
map <- get_map(
    location = bbox, 
    maptype = "watercolor", 
    source = "stamen", 
    force = T,
    zoom = 5)
ggmap(map) +
    geom_point(
        data = df, 
        shape = 21,
        mapping = aes(
            x = longitude, 
            y = latitude,
            bg = botanical_variety
        )) +
    scale_fill_brewer(palette="Accent") +
    labs(
        bg="Botanical variety", 
        subtitle = "Georeferenced accessions",
        title = "Neotropical landraces, cultivars and wild tomatoes",
        caption = "Adapted from doi:10.1038/ng.3117"
    )


