
library(ggplot2)

#function that takes in a dataset, covariates and metric to evaluate and spits out the glm_model
create_glm_model <- function(covariates, data, metric) {
  
  #starts off with the first covariate the user picks
  equation <- paste(metric, covariates[1], sep = " ~ ")
  
  #if the user selects more than one covariate, then we paste them on with "+" 
  if (length(covariates) > 1) {
    for (covariate in covariates[2:length(covariates)]) {
      equation <- paste(equation, covariate, sep = " + ")
    }
  }
  
  #create a glm_model by passing in the equation with covariates, data, metric
  glm_model <- glm(as.formula(equation), family=binomial(link='logit'), data=data, maxit=100)
  return(glm_model)
}

#store this value
glm_model_val <- create_glm_model(covariates, data, metric)

#calculate and draw best fit curve for sensitivity and false positive for given glm logistic model
draw_best_fit <- function(glm_model_val, covariates, data, metric) {
  fitmetric_pos <- glm_model_val$fitted.values[data[metric] == 1]
  fitmetric_neg <- glm_model_val$fitted.values[data[metric] == 0]
  sort_fitmetric <- sort(glm_model_val$fitted.values)
  
  sens <- 0
  spec <- 0

  for (i in length(sort_fitmetric):1) {
    sens <- c(sens, mean(fitmetric_pos >= sort_fitmetric[i]))
    spec <- c(spec, mean(fitmetric_neg >= sort_fitmetric[i]))
  }
  
  # draw plot
  best_fit_plot <- plot(spec, sens, xlim = c(0, 1), ylim = c(0, 1), type = "l", xlab = "False Positive Rate", ylab = "True Positive Rate", col = 'blue')
  abline(0, 1, col = "black")
  legend("topleft", legend = c("logit") , pch = 15, bty = 'n', col = c("blue"))
  return(best_fit_plot)
}

############### TESTING ###############

data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)
healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)

# Function test dummy data
covariates <- c("leave", "care_options", "wellness_program", "mental_health_interview")
metric <- "ease_communication"

####### YAY IT WORKS #########
draw_best_fit(glm_model_val, covariates, data, metric)
