# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select the following variables: ppt, task, location, next_event_type, event_duration
data <- select(data, ppt, task, location, next_event_type, event_duration)

# group_by: perform an action (function) by level of grouping variable
# group by ppt
data_by_ppt <- group_by(data, ppt)

# Add the ppt means using mutate
mutate(data_by_ppt, ppt_mean = mean(event_duration))

# group by ppt and location
data_grouped <- group_by(data, ppt, location)

# Add the ppt means using mutate
mutate(data_grouped, ppt_loc_mean = mean(event_duration))

# This is useful for e.g. centering variables
mutate(data_grouped, mean_ctr = event_duration - mean(event_duration))
# or
mutate(data_grouped, ppt_loc_mean = event_duration - mean(event_duration),
                     mean_ctr = event_duration - ppt_loc_mean)

# Task: 
# 1. Group data by ppt and task
data_grouped <- group_by(---, ---, ---)

# 2. Add the by ppt and task median to the data.
# 3. Add another variable that is the centred event duration for ppt and task.
# 4. Assign the data to a new variable.


# IMPORTANT: Never forgot to ungroup() your data when your done.
--- <- ungroup(---)
