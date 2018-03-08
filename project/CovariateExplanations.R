# Function that returns a dataframe with columns covariate and 
# definition with the respective information
getCovariateDefinitions <- function() {
  covariate <- c(
    "benefits",
    "care_options",
    "wellness_program",       
    "seek_help",
    "anonymity",
    "leave",                    
    "mental_health_consequence",
    "phys_health_consequence","coworkers",             
    "supervisor",
    "mental_health_interview",
    "phys_health_interview",   
    "mental_vs_physical",
    "obs_consequence")
  definition <- c(
    "Does your employer provide mental health benefits?",
    "Do you know the options for mental health care your employer provides?",
    "Has your employer ever discussed mental health as part of an employee wellness program?",
    "Does your employer provide resources to learn more about mental health issues and how to seek help?",
    "Is your anonymity protected if you choose to take advantage of mental health or substance abuse treatment resources?",
    "How easy is it for you to take medical leave for a mental health condition?",
    "Do you think that discussing a mental health issue with your employer would have negative consequences?",
    "Do you think that discussing a physical health issue with your employer would have negative consequences?",
    "Would you be willing to discuss a mental health issue with your coworkers?",
    "Would you be willing to discuss a mental health issue with your direct supervisor(s)?",
    "Would you bring up a mental health issue with a potential employer in an interview?",
    "Would you bring up a physical health issue with a potential employer in an interview?",
    "Do you feel that your employer takes mental health as seriously as physical health?",
    "Have you heard of or observed negative consequences for coworkers with mental health conditions in your workplace?"
  )
  return(data.frame(covariates, definitions))
}