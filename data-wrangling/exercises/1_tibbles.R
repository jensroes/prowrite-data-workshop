# Load libraries
library(tidyverse)

# Import data as data frame
data <- read.csv("data/prowrite-4-tasks.csv")

# Check out data
View(data) # not a fan :)
head(data) # just print the first rows
str(data) # str of the data

# Import data as tibble
data <- read_csv("data/prowrite-4-tasks.csv")

# Tasks (replace --- correctly)
# Check out data
head(---) # just print the first rows 
# but: just type the name of the data variable in the console
glimpse(---) # str() but better
