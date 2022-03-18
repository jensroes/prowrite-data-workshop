# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select the following variables: ppt, task, location, next_event_type, event_duration
data <- select(data, ppt, task, location, next_event_type, event_duration)

# summarise: summarise the data, e.g. taking the mean
summarise(data, mean = mean(event_duration))

summarise(data, mean = mean(event_duration),
                sd = sd(event_duration))

# group_by: perform an action (function) by level of grouping variable
# Here we want to summarise data as mean and sd by location and next event type
data_grouped <- group_by(data, location, next_event_type)

summarise(data_grouped, mean = mean(event_duration),
                        sd = sd(event_duration))

# oh my! Here is the reason for the NA:
# number of locations by next event type
summarise(data_grouped, n = n())


# proportions

# also count

# event_durations larger than 2 * sd of log event duration
