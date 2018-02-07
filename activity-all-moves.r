# Include libraries
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

# Read the CSV file
filename <- "./moves_export/csv/full/activities.csv"
activities <- read.csv(filename, stringsAsFactors = FALSE)
activities$Date <- mdy(activities$Date)

# Modify the data
activitiesGrouped <- activities %>% 
    select(Date, Activity, Duration) %>%
    group_by(Date, Activity) %>%
    summarise(Duration = sum(Duration / 3600))

# Plot point graph
ggplot(activitiesGrouped, 
       aes(x = Date, y = Duration, color = Activity)
    ) +
    geom_point() +
    theme(axis.title = element_blank(), axis.text.y = element_blank(), 
  axis.ticks.y = element_blank(), axis.text.x = element_text(size = 18, angle = 0))
