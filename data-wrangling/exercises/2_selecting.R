# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Check out variable names
names(data)

# Select variables of interest: getting rid of variables we don't need.
select(data, ppt, task, location, event_duration)

select(data, -t_start_event)

select(data, ends_with("_id"))

select(data, -ends_with("_id"))

select(data, starts_with("n_"))

select(data, -starts_with("n_"))

# Tasks:
# Select the following variables: ppt, task, location, next_event_type, event_duration
select(---)

# Assign the tibble with the selctect variables above to a new data variable
--- <- select(---)

# Check out new data variable using glimpse
glimpse(---)

# Renaming and selecting
# You can rename variables like so
# rename(data, new_name = old_name)
# or do so while selecting your variables of interest
# select(data, new_name = old_name, var2, var3)

# Use select to get a data variable with ppt, task, and event_duration but rename
# event_duration as "iki" 

# You can save your new data in csv format using:
write_csv(new_data_variable, "name_of_target_file.csv")
