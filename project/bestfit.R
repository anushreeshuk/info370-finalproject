
library(ROCR)
library(ggplot2)

# distributions
# compare how much more it

#turn it into a fucntion that will take in a coovariate vector of coovariate
# outcome of interest
# data

###function that takes in a dataset, covariates and metric to evaluate and spits out the glm_model
create_glm_model <- function(covariates, data, metric) {
  
  #starts off with the first covariate the user picks
  equation <- paste(metric, covariates[1], sep = " ~ ")
  
  #if the user selects more than one covariate, then we paste them on with "+" 
  if (length(covariates) > 1) {
    for (covariate in covariates[2:length(covariates)]) {
      equation <- paste(equation, covariate, sep = " + ")
    }
  }

  #create a glm_model by passing in the equation with covariates, data, metric.
  glm_model <- glm(as.formula(equation), family=binomial(link='logit'), data=data, maxit=100)
  
  #set and sort fitted positive and negative metrics to binary values
  fitmetric_pos <- glm_model$fitted[data$metric == 1]
  fitmetric_neg <- glm_model$fitted[data$metric == 0]
  sort_fitmetric <- sort(glm_model$fitted.values)
  
  #set initial values to zero
  sensitivity <- 0
  specificity <- 0
  
  #calculate and set the sensitivity and specificity
  for (i in length(sort_fitmetric):1) {
    sensitivity <- c(sensitivity, mean(fitmetric_pos >= sort_fitmetric[i]))
    specificity <- c(specificity, mean(fitmetric_neg >= sort_fitmetric[i]))
  }
  #calculate and predict sensitivity and false positive measure for glm logistic model
  fitmetric_pos_pred <- as.numeric(glm_model$pred[data$metric == 1]) - 1
  fitmetric_neg_pred <- as.numeric(glm_model$pred[data$metric == 0]) - 1
  sort_fitmetric_pred <- as.numeric(sort(glm_model$pred)) - 1
 
  sensitivity_pred <- 0
  specificity_pred <- 0
  
  for (i in length(sort_fitmetric_pred):1) {
    sensitivity_pred <- (c(sensitivity_pred, mean(fitmetric_pos_pred >= sort_fitmetric_pred[i])))
    specificity_pred <- (c(specificity_pred, mean(fitmetric_neg_pred >= sort_fitmetric_pred[i])))
  }
  
  #plot the best fit line
  best_fit_plot <- plot(specificity, sensitivity, xlim = c(0, 1), ylim = c(0, 1), type = "l", xlab = "False Positive Rate", ylab = "True Positive Rate", col = 'blue')
 
   #create costant abline
  abline(0, 1, col = "black")
  lines(specificity_pred, sensitivity_pred, col='green')
  legend("topleft", legend = c("logit") , pch = 15, bty = 'n', col = c("blue"))
  return(best_fit_plot)
}


############### TESTING ###############

data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)
healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)

# Function test dummy data
covariates <- c("supervisor", "leave", "care_options", "wellness_program", "mental_health_interview")
metric <- "social_acceptance"

# Get the dataframe, then create the histogram
create_glm_model(covariates, data, metric)



# I FIRST NEEDED TO DO THIS THEN REALISED I DONT HAVE TO
# Keeping this here incase I do
# splitting the data into training and testing
# train<-sample_frac(data, 0.75)
# sid <- as.numeric(rownames(train)) # because rownames() returns character
# test <- data [-sid,]
