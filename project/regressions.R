######################################################################
###################### Log Regressions ###############################
######################################################################

#read in data, get rid of state and country data
data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere)

healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)


##running the log regression on all covariates
log_regression <- function(covariate){
  glm(social_acceptance ~ data[[covariate]], family=binomial(link='logit'),data=data)
  return (l)
}

for(covariate in colnames(data)){
  log_regression(covariate)
}

l <- glm(social_acceptance ~ mental_health_consequence, family=binomial(link='logit'),data=data)

data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)
data <- data %>% select(Gender, self_employed, family_history, social_acceptance, treatment, no_employees, remote_work, tech_company, 
                                benefits, care_options, wellness_program, seek_help, anonymity, leave, coworkers, supervisor)
l <- glm(social_acceptance ~ ., family=binomial(link='logit'),data=data)
