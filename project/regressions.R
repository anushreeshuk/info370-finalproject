#Log regression
data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE)

clean_regression_data <- data %>% select(-state, -Country, -X)


##running the log regression on all covariates

log_regression <- function(covariate){
  l <- glm(social_acceptance ~ covariate, family=binomial(link='logit'),data=clean_regression_data)
  return (l)
}

for(covariate in colnames(clean_regression_data)){
  print(covariate)
  if(covariate != "work_interfere" | covariate != "social_acceptance"){
    log_regression(covariate)
  }
}

l <- glm(social_acceptance ~ Gender, family=binomial(link='logit'),data=clean_regression_data)
