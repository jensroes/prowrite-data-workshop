# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select the following variables: ppt, task, location, next_event_type, event_duration
data <- select(data, ppt, task, location, next_event_type, event_duration)

# Remove between-paragraph locations and 
# events shorter than 50 ms and longer than 5,000 msecs.
data <- filter(data, 
               location != "post-paragraph", 
               event_duration > 50, 
               event_duration < 5000)

# Make sure you code has worked!

# mutate, then! mutate is a function that allows you to create and change 
# variables in your data.
# Like so:
# mutate(data, new_variable = some_function(old_variable))
mutate(data, log_event_duration = log(event_duration))

mutate(data, event_duration_times_2 = event_duration + event_duration)

mutate(data, event_duration_sq = event_duration^2)

mutate(data, is_pause = event_duration > 2000)

mutate(data, log_event_duration = log(event_duration),
             is_pause = event_duration > 2000)

# Task: is_pause should only be TRUE if event_duration is larger than 2secs and
# the next_event_type is production. You can combine conditions with &