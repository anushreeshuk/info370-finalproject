######################################################################
###################### Log Regressions ###############################
######################################################################

#read in data, get rid of state and country data
data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere)

healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)

##predict and run log regressions
#predIll = glm.predict()

##running the log regression on all covariates
#log_regression <- function(covariate){
#  glm(social_acceptance ~ data[[covariate]], family=binomial(link='logit'),data=data)
#  return (glm_social)
#}

##running the log regression on all covariates & new variables
log_regression_com <- function(covariate, col) {
  glm(col ~ data[[covariate]], family = binomial(link='logit'), data=data)
  return (glm)
}

#predRed = glm.predict()
#data['def_pred_binary'] = (data['df_predict'] > 0.5)
#df['def_pred_binary'] = df['def_pred_binary'].apply(lambda x: 1 if x == True else 0)
#plt.show()

#data['df_predict'] = inter_model.predict()

for(covariate in colnames(data)){
  log_regression(covariate)
}

glm_social <- glm(social_acceptance ~ mental_health_consequence, family=binomial(link='logit'),data=data)
data['predict'] = glm_social.predict()
glm_social.summary()


data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)

data <- data %>% select(Gender, self_employed, family_history, social_acceptance, treatment, no_employees, remote_work, tech_company, 
                                benefits, care_options, wellness_program, seek_help, anonymity, leave, coworkers, supervisor)

glm_social <- glm(social_acceptance ~ ., family=binomial(link='logit'),data=data)
