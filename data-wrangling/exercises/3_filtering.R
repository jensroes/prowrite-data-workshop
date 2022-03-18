# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select variables
data <- select(data, ppt, task, location, next_event_type, event_duration)

# Filtering data: keeping data that fulfill our inclusion criteria.
filter(data, event_duration > 144)

filter(data, event_duration >= 144)

filter(data, event_duration < 144)

filter(data, event_duration > 144, event_duration < 500)

filter(data, event_duration < 50 | event_duration > 5000)

filter(data, task == "A")

filter(data, task != "A")

filter(data, task %in% c("A", "B"))

filter(data, !(task %in% c("A", "B")))

# How do you know the names for task?
count(data, task)

# or
unique(data$task)

# Task: 
# Filter for the following conditions:
# All tasks and ppts
# Location should be everything but event duration from between paragraph 
# Event durations that are larger than 50 msecs and smaller than 5,000 msecs
filter(data, ---)

# Assign the result to a new data variable
--- <- filter(data, ---)

# Inspect new data variable using glimpse
glimpse(---)

# How do you know your filter code was successful 
# (other than confidence in your coding abilities)?

