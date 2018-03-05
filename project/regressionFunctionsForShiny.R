library(plotly)

#read in data, get rid of state and country data
data <-read.csv("./data/clean_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X, -work_interfere, -mental_health_consequence, -phys_health_consequence)

healthy_data <- read.csv("./data/healthy_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)
illness_data <- read.csv("./data/illness_data.csv", stringsAsFactors = FALSE) %>% select(-state, -Country, -X)


# Function test dummy data
covariates <- c("supervisor", "leave", "care_options", "wellness_program", "mental_health_interview")
metric <- "social_acceptance"

# Metric eg "social_acceptance" a string yo
# Data
# Covariates, a vector of covariates strings

# This function takes in covariates and plots the p values for those given covariates and data
# @data CSV file that has been read in, can be "clean", or "illness" etc.
# @covariates vector of covariates in a string format eg c("supervisor", "leave") etc.
# @metric string that we want to measure eg "social_acceptance"
# Returns plot of the p valuesof the glm regression
plotPValues <- function(data, covariates, metric) {
  # Sanity check, make sure that we have at least one covariate
  if (length(covariates) < 1) {
    print("Length of covariates must be larger than 0")
    return;
  }
  # Cool, lets slap on the first covariate.
  equation <- paste(metric, covariates[1], sep=" ~ ")
  # If we have more covariates, we want to paste them on with a "+" separator
  if (length(covariates) > 1) {
    for(covariate in covariates[2:length(covariates)]) {
      equation <- paste(equation, covariate, sep=" + ")
    }
  }
  # Finally, we create a model, and return the plot of the p value.
  model <- glm(as.formula(equation), family=binomial(link='logit'), data=data, maxit=100)
  pValVector <- as.vector((coef(summary(model))[,4]))
  
  print(coef(summary(model))[,4]) # Debug print for checking
  
  # Actually create the plot
  p <- plot_ly(x = covariates, y = pValVector[2:length(pValVector)],title='Covariate P Values')%>%
    layout(title = "p Values for covariates",
           xaxis = list(title = 'Co Variate',
                        zeroline = TRUE),
           yaxis = list(title = "P Value"))
  return(p)
}

# TEST IT OUT
plotPValues(data, covariates, metric)
