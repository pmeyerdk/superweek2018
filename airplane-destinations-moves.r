# Include libraries
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

# Read the CSV file
filename <- "./moves_export/csv/full/storyline.csv"
storyline <- read.csv(filename, stringsAsFactors = FALSE)

# Modify the data
destinations <- storyline %>%
    # Get needed columns
    select(Name, Duration) %>%
    # Only include non-walking activity
    filter(Name != 'walking') %>%
    # Define column as following rows Name value
    mutate(Destination = dplyr::lead(Name, n = 1, default = NA)) %>%
    # Remove 'Place in' text from Destination value
    mutate(Destination = str_replace(Destination, 'Place in ', '')) %>%
    # Only include airplane trips to destinations != Kastrup (Home airport) 
    filter(Name == 'airplane' & Destination != 'Kastrup') %>% 
    # Merge Budapest rows
    mutate(Destination = replace(Destination, Destination %in% 
   c('Pestlőrinc, Budapest', 'Vecsés'), 'Budapest')) %>%
    # Group by Destination names
    group_by(Destination) %>%
    # Summarise duration lenght in hours, and count occurences
    summarise(Duration = sum(Duration / 3600), Count = n()) %>%
    # Only include Top 10 trip durations
    filter(rank(desc(Duration)) <= 10)

# Plot Duration data as bar chart
ggplot(destinations,
       aes(x = reorder(Destination, -Duration), y = Duration, fill = Destination)
    ) +
    geom_bar(stat="identity") +
    theme(legend.position="none", axis.title.x = element_blank(), 
          axis.text.x = element_text(size = 18))

# Plot Count data as bar chart
ggplot(destinations,
       aes(x = reorder(Destination, -Count), y = Count, fill = Destination)
    ) +
    geom_bar(stat="identity") +
    theme(legend.position="none", axis.title.x = element_blank(),
          axis.text.x = element_text(size = 18))
