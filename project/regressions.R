#Log regression
model <- glm(social_acceptance ~ family_history, family=binomial(link = "logit"), data=cleaning)
summary(model)
