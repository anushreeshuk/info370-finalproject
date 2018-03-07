######################################################################
###################### Log Regressions ###############################
######################################################################

library(dplyr)

#read in data, get rid of state and country data
data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)

healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)

##running the log regression on all covariates
log_regression <- function(covariate){
  l <- glm(social_acceptance ~ data[[covariate]], family=binomial(link='logit'), data=data, maxit=100)
  print(summary(l))
  return (l)
}

##running the log regression on all covariates & new variables
#log_regression_com <- function(covariate, col) {
#  glm(col ~ data[[covariate]], family = binomial(link='logit'), data=data)
#  return (glm)
#}

for(covariate in colnames(data)){
  log_regression(covariate)
}

summary(glm(social_acceptance ~., family=binomial(link='logit'), data=data), maxit=100)


summary(glm(social_acceptance ~ Gender+self_employed, family=binomial(link='logit'), data=data, maxit=100))


glm_social <- glm(social_acceptance ~ mental_health_consequence, family=binomial(link='logit'),data=data)
data['predict'] = glm_social.predict()
glm_social.summary()