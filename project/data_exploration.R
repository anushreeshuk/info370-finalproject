#Data Exploration

#setup
#install.packages("dplyr", "tidyr")
library(dplyr)
library(tidyr)

#setwd("C:/Users/Rosemary/Documents/Info/370/info370-finalproject/project")

raw.data <- read.csv("./data/raw_data.csv", stringsAsFactors = FALSE)

#Remove timestamp and age
cleaning <- raw.data %>% select(-Timestamp, -Age) 

#yes/no answer function
yesno <- function(x) {
  x <- sapply(x, tolower)
  print(x)
  x[x=='no'] <- 0
  x[x=='yes'] <- 1
  return (x);
}

#cleaning gender: nonbinary 0, female 1, male 2
cleaning$Gender <- sapply(cleaning$Gender, tolower)
cleaning$Gender[cleaning$Gender=='f'|cleaning$Gender=='female'|cleaning$Gender=='woman'|cleaning$Gender=='femake'|cleaning$Gender=='femail'|cleaning$Gender=='female '] <- 1
cleaning$Gender[cleaning$Gender=='m'|cleaning$Gender=='male'|cleaning$Gender=='man'|cleaning$Gender=='mal'|cleaning$Gender=='make'|cleaning$Gender=='msle'|cleaning$Gender=='malr'|cleaning$Gender=='maile'|cleaning$Gender=='male '|cleaning$Gender=='mail'] <- 2
cleaning$Gender[(cleaning$Gender != 1) & (cleaning$Gender != 2)] <- 0

#self employed: na = no, no = 0, yes = 1
cleaning$self_employed[is.na(cleaning$self_employed)] <- 'no'
cleaning$self_employed <- yesno(cleaning$self_employed)

#family history: yes = 1, no = 1
cleaning$family_history <- yesno(cleaning$family_history)

#sought treatment: yes = 1, no = 1
cleaning$treatment <- yesno(cleaning$treatment)

#work interfere: never = 0, rarely = 1, often = 2, sometimes = 3; keep NAs
cleaning$work_interfere <- sapply(cleaning$work_interfere, tolower)
cleaning$work_interfere[cleaning$work_interfere=='never'] <- 0
cleaning$work_interfere[cleaning$work_interfere=='rarely'] <- 1
cleaning$work_interfere[cleaning$work_interfere=='often'] <- 2
cleaning$work_interfere[cleaning$work_interfere=='sometimes'] <- 3

#num employees: Range: 1-5: 0    6-25: 1    26-100: 2    100-500: 3   500-1000: 4    more than 1000: 5
cleaning$no_employees <- sapply(cleaning$no_employees, tolower)
cleaning$no_employees[cleaning$no_employees=='1-5'] <- 0
cleaning$no_employees[cleaning$no_employees=='6-25'] <- 1
cleaning$no_employees[cleaning$no_employees=='26-100'] <- 2
cleaning$no_employees[cleaning$no_employees=='100-500'] <- 3
cleaning$no_employees[cleaning$no_employees=='500-1000'] <- 4
cleaning$no_employees[cleaning$no_employees=='more than 1000'] <- 5

#remote work, yes no
cleaning$remote_work <- yesno(cleaning$remote_work)

#tech company
cleaning$tech_company <- yesno(cleaning$tech_company)


#supervisors
cleaning$supervisor <- yesno(cleaning$supervisor)

#benefits - changing don't know to no and then yes no to 1 0 respectively
cleaning$benefits[cleaning$benefits == "Don't know"] <- 'no'
cleaning$benefits <- yesno(cleaning$benefits)

#care options - not sure to no and then yes no to 1 0
cleaning$care_options[cleaning$care_options == "Not sure"] <- 'no'
cleaning$care_options <- yesno(cleaning$care_options)

#welless program - changed don't know to no and yes no to 1 0
cleaning$wellness_program[cleaning$wellness_program == "Don't know"] <- 'no'
cleaning$wellness_program <- yesno(cleaning$wellness_program)

#seek help
cleaning$seek_help[cleaning$seek_help == "Don't know"] <- 'no'
cleaning$seek_help <- yesno(cleaning$seek_help)

#leave - it's a range!


