#Data Exploration

#setup
#install.packages("dplyr", "tidyr")
library(dplyr)
library(tidyr)

setwd("C:/Users/Rosemary/Documents/Info/370/info370-finalproject/project")

raw.data <- read.csv("./data/raw_data.csv", stringsAsFactors = FALSE)
