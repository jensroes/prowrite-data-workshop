# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select the following variables: ppt, task, location, next_event_type, event_duration
data <- select(data, ppt, task, location, next_event_type, event_duration)

# summarise: summarise the data, e.g. taking the mean of event duration
summarise(data, mean = mean(---))

# get both the mean and the sd of event duration
summarise(data, mean = mean(---),
                sd = sd(---))

# group_by: perform an action (function) by level of grouping variable
# Here we want to summarise data as mean and sd by location and next event type
data_grouped <- group_by(data, ---, ---)

summarise(data_grouped, mean = mean(---),
                        sd = sd(---))

# oh my! Here is the reason for the NA:
# number of locations by next event type
summarise(data_grouped, n = n())

# which is the same as:
count(data_grouped)

# Think: what happens if I add sum(n)?
summarise(data_grouped, n = n(),
                        sum_n = sum(n))

# Getting the proportion of long event durations
summarise(data_grouped, long_events = mean(--- > 2000))

# How do we get the % of long event durations?

# Here is a tricky one:
# For the grouped data, get the % of event_durations that are 
# 2 x SDs above the mean of log event duration.
# Using the log is important because event durations are positively skewed
summarise(data_grouped, long_events = 100 * mean(--- > ---))

