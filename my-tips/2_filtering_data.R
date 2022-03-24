# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Small data for illustration
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
filter(data, str_detect(location, "sentence"))

# Exercise: filter for 
#- all word locations that weren't before a new sentence and
#- where the next event wasn't a text modification and 
#- where event durations where smaller than 100 ms or larger than 7500 mses
newdata <- filter(data, ---, 
                        ---,
                        ---)