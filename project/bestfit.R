source('regressions.R')
library(ROCR)
library(ggplot2)


# glm social acceptance model
glm_model <- (glm(social_acceptance ~., family=binomial(link='logit'), data=data))
summary(glm_model)

fity_ypos <- glm_model$fitted[data$social_acceptance == 1]
fity_yneg <- glm_model$fitted[data$social_acceptance == 0]

sort_fity <- sort(glm_model$fitted.values)

sens <- 0
spec_c <- 0

for (i in length(sort_fity):1){
  sens <- c(sens, mean(fity_ypos >= sort_fity[i]))
  spec_c <- c(spec_c, mean(fity_yneg >= sort_fity[i]))
  
} 

# Calculate sensitivity and false positive measure for glm logistic model

fity_ypos2 <- as.numeric(glm_model$pred[data$social_acceptance == 1]) - 1
fity_yneg2 <- as.numeric(glm_model$pred[data$social_acceptance == 0]) - 1

sort_fity2 <- as.numeric(sort(glm_model$pred)) - 1

sens2 <- 0
spec_c2 <- 0

for (i in length(sort_fity2):1){
  sens2 <- (c(sens2, mean(fity_ypos2 >= sort_fity2[i])))
  spec_c2 <- (c(spec_c2, mean(fity_yneg2 >= sort_fity2[i])))
} 

# Plot the ROC Curve
plot(spec_c, sens, xlim = c(0, 1), ylim = c(0, 1), type = "l", xlab = "False Positive Rate", ylab = "True Positive Rate", col = 'blue')
abline(0, 1, col= "black")
lines(spec_c2, sens2, col='green')
legend("topleft", legend = c("logit") , pch = 15, bty = 'n', col = c("blue"))


# I FIRST NEEDED TO DO THIS THEN REALISED I DONT HAVE TO
# Keeping this here incase I do
# splitting the data into training and testing 
# train<-sample_frac(data, 0.75)
# sid <- as.numeric(rownames(train)) # because rownames() returns character
# test <- data [-sid,]
