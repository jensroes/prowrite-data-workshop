# Load libraries
library(tidyverse)

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")
glimpse(data)

# select with index, start_with(), ends_with(), contains()
select(data, z_start, edge_id, pretext)
select(data, z_start:pretext)
select(data, 2:4)
select(data, starts_with("n_"))
select(data, ends_with("_run"))
select(data, contains("fix"))
select(data, where(is.numeric))

# removing variables
select(data, -z_start, -edge_id, -pretext)
select(data, -z_start:-pretext)
select(data, -starts_with("n_"))

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

data <- data %>% filter(event_duration > 50, event_duration < 10000)


# mutate across
mutate(data, event_duration = log(event_duration))
mutate(data, across(event_duration, log))
mutate(data, across(event_duration, ~.^2))
mutate(data, across(where(is.numeric), log))
mutate(data, across(starts_with("event_"), log))
mutate(data, across(c(task, location), factor))
mutate(data, across(where(is.character), factor))
mutate(data, across(task, ~paste("task: ", .)))


# Summary data for next examples
data_means <- data %>% mutate(is_prod = next_event_type == "production") %>%
  group_by(ppt, task, location) %>%
  summarise(sum_del = length(is_prod) - sum(is_prod)) %>%
  ungroup() 

# Pivot wider
data_wide <- pivot_wider(data_means, names_from = task, values_from = sum_del, names_prefix = "Task: ")

# mutate c_across and starts_with()
mutate(data_wide, total = `Task: A` + `Task: B` + `Task: followup` + `Task: intervention`)
mutate(data_wide, total = sum(c_across(starts_with("Task")), na.rm = TRUE))

rowwise(data_wide) %>%
  mutate(total = sum(c_across(starts_with("Task")))) %>%
  ungroup()


# Pivot longer
data_wide %>%
  pivot_longer(starts_with("Task"))

data_wide %>%
  pivot_longer(starts_with("Task"), names_to = "task", values_to = "sum_del")

data_wide %>%
  pivot_longer(starts_with("Task"), names_to = "task", values_to = "sum_del", names_prefix = "Task: ")


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


# Using map instead of for loops

files <- list.files(path = "data", pattern = "data", full.names = TRUE)

data <- tibble()
for(file in files){
  data <- read_csv(file) %>%
    bind_rows(data)
}

map(files, read_csv)
map_dfr(files, read_csv)
map_dfr(files, ~read_csv(.x) %>%
          mutate(file_id = .x)) 



# Converting values back
library(lme4)
library(broom.mixed)
data <- read_csv("data/prowrite-4-tasks.csv") %>%
  select(ppt, task, next_event_type) %>%
  mutate(is_prod = next_event_type == "production")

m1 <- glmer(is_prod ~ 0 + task + (task|ppt), data = data, family = binomial())

#tidy(m1, effects="fixed", conf.int = TRUE) %>%
#  mutate(across(c(estimate, conf.low, conf.high), plogis))
data_bin <- data %>%
  group_by(ppt, task) %>%
  summarise(is_prod = sum(is_prod),
            not_prod = n()-is_prod) %>%
  ungroup()
  
m2 <- glmer(cbind(is_prod, not_prod) ~ 0 + task + (task|ppt), data = data_bin, family = binomial())

model_tidy <- tidy(m2, effects="fixed", conf.int = TRUE) %>%
  mutate(across(c(estimate, conf.low, conf.high), plogis),
         across(term, str_remove, "term"))

ggplot(model_tidy, aes(y = estimate, ymin = conf.low, ymax = conf.high, x = term)) +
  geom_pointrange()

augment(m2, data_bin) %>%
  mutate(across(.fitted, plogis),
         across(task, ~factor(., levels = c("A", "B", "intervention", "followup"), ordered = T) )) %>%
  ggplot(aes(y = .fitted, x = task, colour = ppt, group = interaction(ppt))) +
  geom_point() +
  geom_line()

