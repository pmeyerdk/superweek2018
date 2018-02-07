# Include libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# Read the ICS file
filename <- "./foursquare_export/qwerty123456.ics"
checkins <- read.delim(filename, header = FALSE, sep = ":")
names(checkins) <- c("key", "value")

# Modify the data
checkinsCount <- checkins %>% 
    filter(key == "LOCATION") %>%
    add_count(value, sort = TRUE) %>%
    unique() %>%
    filter(rank(desc(n))<=10)

# Plot Top 10 graph
ggplot(checkinsCount, 
       aes(x = reorder(value, -n), y = n, fill = value)
    ) +
    geom_bar(stat="identity") +
    theme(legend.position="none", axis.title = element_blank(), 
  axis.text.y = element_blank(), axis.ticks.y = element_blank(), 
  axis.text.x = element_text(size = 18, angle=65, vjust=0.6))
