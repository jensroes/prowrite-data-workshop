library(tidyverse)

data <- read_csv("data/prowrite-4-tasks.csv")

ppts <- unique(data$ppt)

for(p in ppts){
  tmp <- filter(data, ppt == p) 
  write_csv(tmp, paste0("data/data_", p, ".csv"))
}

