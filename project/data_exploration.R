#Data Exploration
#setup
#install.packages("dplyr")
#install.packages("tidyr")
library(dplyr)
library(tidyr)

#setwd("C:/Users/Rosemary/Documents/Info/370/info370-finalproject/project")
#setwd("/Users/calvinkorver/Documents/code/info370/info370-finalproject/project")

raw.data <- read.csv("./data/raw_data.csv", stringsAsFactors = FALSE)

###############################################################################################
################################# helper functions ############################################
###############################################################################################

#yes/no answer function
#takes in a column and codes each 'yes' to a 1 and 'no' to a 0
yesno <- function(x) {
  x <- sapply(x, tolower)
  x[x=='no'] <- 0
  x[x=='yes'] <- 1
  return (x);
}

##############################################################################################
################################### permanent cleaning #######################################
##############################################################################################

#Remove timestamp and age and comments (we won't be using these in our analysis)
cleaning <- raw.data %>% select(-Timestamp, -Age, -comments) 

##############column by column cleaning#####################

#gender: nonbinary 0, female 1, male 2
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

#num employees: Range: 1-5: 0    6-25: 1    26-100: 2    100-500: 3   500-1000: 4    more than 1000: 5
cleaning$no_employees <- sapply(cleaning$no_employees, tolower)
cleaning$no_employees[cleaning$no_employees=='1-5'] <- 0
cleaning$no_employees[cleaning$no_employees=='6-25'] <- 1
cleaning$no_employees[cleaning$no_employees=='26-100'] <- 2
cleaning$no_employees[cleaning$no_employees=='100-500'] <- 3
cleaning$no_employees[cleaning$no_employees=='500-1000'] <- 4
cleaning$no_employees[cleaning$no_employees=='more than 1000'] <- 5

#remote work
cleaning$remote_work <- yesno(cleaning$remote_work)

#tech company
cleaning$tech_company <- yesno(cleaning$tech_company)

#work interfere (leave NA values in)
cleaning$work_interfere[cleaning$work_interfere == "Never"] = 0
cleaning$work_interfere[cleaning$work_interfere == "Rarely"] = 1
cleaning$work_interfere[cleaning$work_interfere == "Often"] = 2
cleaning$work_interfere[cleaning$work_interfere == "Sometimes"] = 3

#supervisors
cleaning$supervisor <- yesno(cleaning$supervisor)

#obs_consequence
cleaning$obs_consequence <- yesno(cleaning$obs_consequence)

#benefits - don't know = 0, no = 0, yes = 1
cleaning$benefits[cleaning$benefits == "Don't know"] <- 'no'
cleaning$benefits <- yesno(cleaning$benefits)

#care options - not sure = 0, yes = 1, no = 0
cleaning$care_options[cleaning$care_options == "Not sure"] <- 'no'
cleaning$care_options <- yesno(cleaning$care_options)

#welless program - don't know = 0, yes = 1, no = 0
cleaning$wellness_program[cleaning$wellness_program == "Don't know"] <- 'no'
cleaning$wellness_program <- yesno(cleaning$wellness_program)

#seek help - don't know = 0, yes = 1, no = 0
cleaning$seek_help[cleaning$seek_help == "Don't know"] <- 'no'
cleaning$seek_help <- yesno(cleaning$seek_help)

#leave - very difficult = 0 somewhat difficult = 1 Don't know = 2 somewhat easy = 3 very easy = 4  
cleaning$leave[cleaning$leave == 'Very difficult'] <- 0
cleaning$leave[cleaning$leave == 'Somewhat difficult'] <- 1
cleaning$leave[cleaning$leave == "Don't know"] <- 2
cleaning$leave[cleaning$leave == 'Very easy'] <- 3
cleaning$leave[cleaning$leave == 'Somewhat easy'] <- 4

#anonymity - yes = 1 don't know = 0.5 no = 0
cleaning$anonymity[cleaning$anonymity == "Don't know"] <- 0.5
cleaning$anonymity <- yesno(cleaning$anonymity)

#mental health consequences - yes = 1 maybe = 0.5 no = 0
cleaning$mental_health_consequence[cleaning$mental_health_consequence=='Maybe'] <- 0.5
cleaning$mental_health_consequence <- yesno(cleaning$mental_health_consequence)

#phys_health_consequence - range, yes: 1, maybe: 0.5, no: 0
cleaning$phys_health_consequence[cleaning$phys_health_consequence == "Maybe"] <- 0.5
cleaning$phys_health_consequence <- yesno(cleaning$phys_health_consequence)

#coworkers - range, yes: 1, some of them: 0.5, no: 0
cleaning$coworkers[cleaning$coworkers == "some of them"] <- 0.5
cleaning$coworkers <- yesno(cleaning$coworkers)

#supervisor - range, yes: 1, some of them: 0.5, no: 0
cleaning$supervisor[cleaning$supervisor == "some of them"] <- 0.5
cleaning$supervisor <- yesno(cleaning$supervisor)

#mental_health_interview - range, yes: 1, maybe: 0.5, no: 0
cleaning$mental_health_interview[cleaning$mental_health_interview == "Maybe"] <- 0.5
cleaning$mental_health_interview <- yesno(cleaning$mental_health_interview)

#phys_health_interview - range, yes: 1, maybe: 0.5, no: 0
cleaning$phys_health_interview[cleaning$phys_health_interview == "Maybe"] <- 0.5
cleaning$phys_health_interview <- yesno(cleaning$phys_health_interview)

#mental vs physical - range, yes = 1 don't know - 0.5 no = 0
cleaning$mental_vs_physical[cleaning$mental_vs_physical == "Don't know"] <- 0.5
cleaning$mental_vs_physical <- yesno(cleaning$mental_vs_physical)

################################################################################################
################################# Calculating Acceptance #######################################
################################################################################################


# Calculates the "social acceptance" score of the row. 
# If anonymity is yes ( 1), 
# if leave is somewhat easy or very easy (3 or 4)
# if mental health consequence is no (0)
# if supervisor is yes (1)
# and obs_consequence is no (0)
# If all these criteria are met, they get a "socially accepted" score of 1.
# If not, they get a "socially accepted" score of 0.
cleaning$social_acceptance <- 0
cleaning$social_acceptance[cleaning$anonymity == 1 & 
                          (cleaning$leave == 3 | cleaning$leave == 4) &
                           cleaning$mental_health_consequence == 0 &
                           cleaning$supervisor == 1 &
                           cleaning$obs_consequence == 0] <- 1

write.csv(cleaning, "./data/clean_data.csv")



################################################################################################
##################################### Dealing with work interfere ##############################
################################################################################################

#for now let's break the clean data set into two - one for people who have indicated that they
#have a mental illness, and one for people who did not. We can compare the experiences of those 
#two groups against each other as we identify covariates of interest

illness_data <- cleaning %>%
                filter(!is.na(cleaning$work_interfere))

write.csv(illness_data, "./data/illness_data.csv")

healthy_data <- cleaning %>%
                filter(is.na(cleaning$work_interfere))

write.csv(healthy_data, "./data/healthy_data.csv")


