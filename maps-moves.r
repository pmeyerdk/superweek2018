# Include libraries
library(dplyr)
library(tidyr)
library(ggmap)

# Read the CSV file
filename <- "./moves_export/csv/full/places.csv"
places <- read.csv(filename, stringsAsFactors = FALSE)

# Modify the data
placesGrouped <- places %>% 
    select(Latitude, Longitude, Duration) %>%
    group_by(Latitude, Longitude) %>%
    summarise(Duration = sum(Duration / 60))

# Get map
map <- get_map(location = 'Hungary', zoom = 7) # Nice illustration

# Plot data on map
ggmap(map, extent = "device") +
    # Outline
    geom_density2d(data = placesGrouped, 
                   aes(x = Longitude, y = Latitude), 
                   size = 0.3) + 
    # Heatmap
    stat_density2d(data = placesGrouped,
        aes(x = Longitude, y = Latitude, 
            fill = ..level.., alpha = ..level..), 
        size = 0.01,
        show.legend = FALSE,
        bins = 16, geom = "polygon") + 
        scale_fill_gradient(low = "green", high = "red") + 
        scale_alpha(range = c(0.0, 0.3), guide = FALSE)
