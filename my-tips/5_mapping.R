# Load libraries
library(tidyverse)

# Using map instead of for loops

# Get file names
files <- list.files(path = "data", pattern = "data", full.names = TRUE)

# Load data in for-loop
data <- tibble()
for(file in files){
  data <- read_csv(file) %>%
    bind_rows(data)
}

# Using map instead
map(files, read_csv)
map_dfr(files, read_csv)
map_dfr(files, ~read_csv(.x) %>%
          mutate(file_id = .x)) 

# Prep data
data <- map_dfr(files, read_csv) %>%
  select(ppt, task, next_event_type) %>%
  mutate(is_prod = next_event_type == "production")


# Exercise:
# -do not use group_by but map, add a column to data that shows the mean of 
# all rows that are *not* is_prod == TRUE by participant.

