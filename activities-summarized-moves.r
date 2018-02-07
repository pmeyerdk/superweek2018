# Include libraries
library(dplyr)
library(tidyr)
library(ggplot2)

# Read the CSV file
filename <- "./moves_export/csv/full/activities.csv"
activities <- read.csv(filename, stringsAsFactors = FALSE)

# Modify the data
activitiesGrouped <- activities %>% 
    select(Activity, Duration) %>%
    group_by(Activity) %>%
    summarise(Duration = sum(Duration))

# Plot bar chart
ggplot(activitiesGrouped, 
       aes(x = Activity, y = Duration, fill = Activity)
    ) +
    geom_bar(stat="identity") +
    theme(legend.position="none", axis.title = element_blank(),
  axis.text.y = element_blank(), axis.ticks.y = element_blank(), 
  axis.text.x = element_text(size = 18, angle = 0))
