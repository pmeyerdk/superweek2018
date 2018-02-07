# Include libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)

# Read the ICS file
filename <- "./foursquare_export/qwerty12345.ics"
checkins <- read.delim(filename, header = FALSE, sep = ":")
names(checkins) <- c("key", "value")

# Modify the data
checkinsCount <- checkins %>% 
    filter(key == "GEO") %>%
    add_count(value, sort = TRUE) %>%
    unique() %>%
    separate(value, c("Latitude", "Longitude"), sep = ";", convert = TRUE)

# Get map
map <- get_map(location = '2300 Amagerbro, Denmark', zoom = 12)

# Plot data on map
ggmap(map, extent = "device") +
    # Outline
    geom_density2d(data = checkinsCount,
                    aes(x = Longitude, y = Latitude),
                    size = 0.3) +
    # Heatmap
    stat_density2d(data = checkinsCount,
                   aes(x = Longitude, y = Latitude,
                       fill = ..level.., alpha = ..level..),
                   size = 0.01, show.legend = FALSE,
                   bins = 16, geom = "polygon") +
    scale_fill_gradient(low = "green", high = "red") +
    scale_alpha(range = c(0.0, 0.3), guide = FALSE)
