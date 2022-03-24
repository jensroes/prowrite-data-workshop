# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Select the following variables: ppt, task, location, next_event_type, event_duration
data <- select(data, ppt, task, location, next_event_type, event_duration)

# Changing the format of data from long to wide and back.

# Before, we need to aggregate the data a little (for practical reasons, really).

# Group data
data_grouped <- group_by(data, ppt, task, location) 

# Summarise data by group
data_summarised <- summarise(data_grouped, mean_dur = mean(event_duration))

# Ungroup data!!!
data_summarised <- ungroup(data_summarised)

# The data has now one value (mean duration) per ppt x task x location
data_summarised

# Wide data format
pivot_wider(data_summarised, names_from = task, values_from = mean_dur)

# and back to long
pivot_longer(data_wide, A:intervention, names_to = "task", values_to = "mean_dur")


data_wide <- pivot_wider(data_summarised, names_from = task, values_from = mean_dur)

# This is useful, for example, if you want to calculate the difference between tasks
mutate(data_wide, diff_intervention = (A + B)/2 - intervention,
                  diff_followup = followup - intervention)

