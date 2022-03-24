# Load libraries
library(tidyverse)

# Import data as tibble
data_all <- read_csv("data/prowrite-4-tasks.csv")

# Instead of 
data <- select(data_all, ppt, task, location, next_event_type, event_duration)

# we can do 
data <- data %>% select(ppt, task, location, next_event_type, event_duration)

# How would you pipe this one:
data_filtered <- filter(data, event_duration > 2000)

# How would you pipe this one:
data_grouped <- group_by(data, ppt, task)

# How would you pipe this one:
data_grouped <- group_by(data, ppt, task)
data_summarised <- summarise(data_grouped, mean = mean(event_duration))
data_ungrouped <- ungroup(data_summarised)

