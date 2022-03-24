# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv") %>% 
  filter(event_duration > 50, event_duration < 10000) %>%
  select(ppt, task, location, next_event_type, event_duration)

# Pivot wider from previous script:
data_wide <- pivot_wider(data_means, 
                         names_from = task, 
                         values_from = sum_del, 
                         names_prefix = "Task: ")

# Pivot longer
data_wide %>%
  pivot_longer(starts_with("Task"))

data_wide %>%
  pivot_longer(starts_with("Task"), 
               names_to = "task", 
               values_to = "sum_del")

data_wide %>%
  pivot_longer(starts_with("Task"), 
               names_to = "task", 
               values_to = "sum_del", 
               names_prefix = "Task: ")


# Pivoting multiple variables at once (this wasn't easily possibly before pivot_)

# Summary for example
data_eventdur <- data %>% 
  mutate(across(event_duration, log)) %>%
  group_by(task, location, next_event_type) %>%
  summarise(across(event_duration, list(mean = mean, sd = sd), .names = "{.fn}"))

# pivot wider
data_wider <- data_eventdur %>%
  pivot_wider(names_from = location, values_from = c(mean, sd))

data_eventdur %>%
  pivot_wider(names_from = location, values_from = c(mean, sd), names_sep = ".")

data_eventdur %>%
  pivot_wider(names_from = location, values_from = c(mean, sd), names_glue = "{location}_{.value}")

data_eventdur %>%
  pivot_wider(-sd, names_from = task, values_from = mean, values_fn = mean)

# back to pivot longer
data_wider %>% 
  pivot_longer(c(starts_with("mean")|starts_with("sd")), 
               names_to = c(".value", "location"),
               names_pattern = "(.*)_(.*)")


# Exercise:
# Arrange data_wide so that the columns do not show tasks but locations
datanew <- pivot_longer(data, ---) %>%
           pivot_wider(---)
