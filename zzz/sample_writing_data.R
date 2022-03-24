library(tidyverse)

data <- read_csv("data/zzz/all_data_incremental.csv") 

keep_ppt <- data %>%count(ppt, task) %>%
  group_by(ppt) %>%
  mutate(n_tasks = n()) %>%
  ungroup() %>%
  filter(n_tasks == 4) %>% 
  pull(ppt) %>% unique()

data <- filter(data, ppt %in% keep_ppt)

write_csv(data, "data/prowrite-4-tasks.csv")
