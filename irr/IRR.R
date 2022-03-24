library(tidyverse)
library(irr)

data <- read_tsv("irr/ZJFinal.copy.tsv") 

codes <- unique(data$Code)

all_combs <- expand_grid(
  Annotator = unique(data$Annotator),
  Item = unique(data$Item), 
  Code = codes)
  
data <- data %>%
  count(Code, Item, Annotator) %>%
  full_join(all_combs) %>%
  mutate(across(n, replace_na, 0))  

map(codes, ~filter(data, Code == .) %>%
      pivot_wider(names_from = Item, values_from = n) %>%
      select(starts_with("SN")) %>%
      as.matrix() %>%
      kripp.alpha(., method = "nominal")) 
