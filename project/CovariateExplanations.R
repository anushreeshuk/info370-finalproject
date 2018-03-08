# Function that returns a dataframe with columns covariate and 
# definition with the respective information
getCovariateDefinitions <- function() {
  covariates <- c(
    "Gender",
    "self_employed",
    "family_history",
    "treatment",
    "no_employees",
    "remote_work",
    "tech_company",
    "benefits",
    "care_options",
    "wellness_program",       
    "seek_help",
    "anonymity",
    "leave",                    
    "mental_health_consequence",
    "phys_health_consequence",
    "coworkers",             
    "supervisor",
    "mental_health_interview",
    "phys_health_interview",   
    "mental_vs_physical",
    "obs_consequence")
  definitions <- c(
    "Gender",
    "Are you self-employed?",
    "Do you have a family history of mental illness?",
    "Have you sought treatment for a mental health condition?",
    "How many employees does your company or organization have?",
    "Do you work remotely (outside of an office) at least 50% of the time?",
    "Is your employer primarily a tech company/organization?",
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
  encodings <- c(
    "nonbinary: 0, female: 1, male: 2",
    "NA: 0, no: 0, yes: 1",
    "yes: 1, no: 0",
    "yes: 1, no: 0",
    "1-5: 0, 6-25: 1, 26-100: 2, 100-500: 3, 500-1000: 4, more than 1000: 5",
    "yes: 1, no: 0",
    "yes: 1, no: 0",
    "don't know: 0, no: 0, yes: 1",
    "not sure: 0, yes: 1, no: 0",
    "don't know: 0, no: 0, yes: 1",
    "don't know: 0, no: 0, yes: 1",
    "yes: 1, don't know: 2, no: 0",
    "very difficult: 0, somewhat difficult: 1, don't know: 2, somewhat easy: 3, very easy: 4",
    "yes: 1, maybe: 2, no: 0",
    "yes: 1, maybe: 2, no: 0",
    "yes: 1, some of them: 2, no: 0",
    "yes: 1, some of them: 2, no: 0",
    "yes: 1, maybe: 2, no: 0",
    "yes: 1, maybe: 2, no: 0",
    "yes: 1, don't know: 2, no: 0",
    "yes: 1, no: 0"
  )
  return(data.frame(covariates, definitions, encodings))
}

getCovariateDefinitions()

