#Data Exploration

#setup
#install.packages("dplyr", "tidyr")
library(dplyr)
library(tidyr)

#setwd("C:/Users/Rosemary/Documents/Info/370/info370-finalproject/project")

raw.data <- read.csv("./data/raw_data.csv", stringsAsFactors = FALSE)
View(unique(raw.data$Gender))

#Remove timestamp and age
cleaning <- raw.data %>% select(-Timestamp, -Age) 

#cleaning gender: nonbinary 0, female 1, male 2
cleaning$Gender <- sapply(cleaning$Gender, tolower)
cleaning$Gender[cleaning$Gender=='f'|cleaning$Gender=='female'|cleaning$Gender=='woman'|cleaning$Gender=='femake'|cleaning$Gender=='femail'|cleaning$Gender=='female '] <- 1
cleaning$Gender[cleaning$Gender=='m'|cleaning$Gender=='male'|cleaning$Gender=='man'|cleaning$Gender=='mal'|cleaning$Gender=='make'|cleaning$Gender=='msle'|cleaning$Gender=='malr'|cleaning$Gender=='maile'|cleaning$Gender=='male '|cleaning$Gender=='mail'] <- 2
cleaning$Gender[(cleaning$Gender != 1) & (cleaning$Gender != 2)] <- 0

#self employed: na = no, no = 0, yes = 1
cleaning$self_employed[is.na(cleaning$self_employed)] <- 'no'
cleaning$self_employed <- sapply(cleaning$self_employed, tolower)
cleaning$self_employed[cleaning$self_employed=='no'] <- 0
cleaning$self_employed[cleaning$self_employed=='yes'] <- 1

#family history: yes = 1, no = 1
cleaning$family_history <- sapply(cleaning$family_history, tolower)
cleaning$family_history[cleaning$family_history=='no'] <- 0
cleaning$family_history[cleaning$family_history=='yes'] <- 1

#sought treatment: yes = 1, no = 1
cleaning$treatment <- sapply(cleaning$treatment, tolower)
cleaning$treatment[cleaning$treatment=='no'] <- 0
cleaning$treatment[cleaning$treatment=='yes'] <- 1

#work interfere: never = 0, rarely = 1, often = 2, sometimes = 3; keep NAs
cleaning$work_interfere <- sapply(cleaning$work_interfere, tolower)
cleaning$work_interfere[cleaning$work_interfere=='never'] <- 0
cleaning$work_interfere[cleaning$work_interfere=='rarely'] <- 1
cleaning$work_interfere[cleaning$work_interfere=='often'] <- 2
cleaning$work_interfere[cleaning$work_interfere=='sometimes'] <- 3