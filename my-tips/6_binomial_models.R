# Load libraries
library(tidyverse)
library(lme4)
library(broom.mixed)

# Get data
data <- read_csv("data/prowrite-4-tasks.csv") %>%
  select(ppt, task, next_event_type) %>%
  mutate(is_prod = next_event_type == "production")

#m1 <- glmer(is_prod ~ 0 + task + (task|ppt), data = data, family = binomial())

#tidy(m1, effects="fixed", conf.int = TRUE) %>%
#  mutate(across(c(estimate, conf.low, conf.high), plogis))

# Pre data
data_bin <- data %>%
  group_by(ppt, task) %>%
  summarise(is_prod = sum(is_prod),
            not_prod = n()-is_prod) %>%
  ungroup()

# Fit model
m2 <- glmer(cbind(is_prod, not_prod) ~ 0 + task + (task|ppt), data = data_bin, family = binomial())

# Get fixed effects
model_tidy <- tidy(m2, effects="fixed", conf.int = TRUE) %>%
  mutate(across(c(estimate, conf.low, conf.high), plogis),
         across(term, str_remove, "term"))

# Visualise fixed effects
ggplot(model_tidy, aes(y = estimate, ymin = conf.low, ymax = conf.high, x = term)) +
  geom_pointrange()

augment(m2, data_bin) %>%
  mutate(across(.fitted, plogis),
         across(task, ~factor(., levels = c("A", "B", "intervention", "followup"), ordered = T) )) %>%
  ggplot(aes(y = .fitted, x = task, colour = ppt, group = interaction(ppt))) +
  geom_point() +
  geom_line()

