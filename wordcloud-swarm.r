# Include libraries
library(dplyr)
library(tidyr)
library(wordcloud)

# Read the ICS file
filename <- "./foursquare_export/qwerty123456.ics"
checkins <- read.delim(filename, header = FALSE, sep = ":")
names(checkins) <- c("key", "value")

# Modify the data
checkinsCount <- checkins %>% 
    filter(key == "LOCATION") %>%
    add_count(value, sort = TRUE) %>%
    unique()

# Plot Word Cloud
wordcloud(words = checkinsCount$value, freq = checkinsCount$n, 
          scale = c(8,.3), min.freq = 1, max.words = 60, 
          random.order = FALSE, rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))
