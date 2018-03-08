#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#load the required libraries and data
#install.packages("plotly")
#install.packages("shinythemes")

library(shiny)
library(plotly)
library(shinythemes)

healthy <- read.csv("./data/healthy_data.csv")
illness <- read.csv("./data/illness_data.csv")
data <- read.csv("./data/clean_data.csv")

data <- data %>% select(-X, -Country, -state, -social_acceptance, -ease_communication, -care_accessibility, -work_interfere)

#generates the list of covariates we can use in the interactive visual
covariates <- colnames(data)

shinyUI(navbarPage("Mental Health in the Workplace",
            tabPanel(
              "Overview",
              mainPanel(
                tags$div(class="jumbotron",
                  tags$h1(class="display-3", "Mental Health in the Workplace"),
                  tags$p(class="lead", "Rosemary Adams | Jessica Libman | Calvin Korver | Anushree Shukla")
                ),
                tags$h2("The Project"),
                tags$p("The purpose of this site is to explore the social acceptance of mental health in the workplace.
                       Our specific question of interest is:"),
                tags$h3("To what extent do different facets of interactions about mental health in the office contribute to the social acceptance of mental health?"),
                tags$p("To answer this question, we have done our own analysis, where we came up with three different measures
                       of social acceptance and have modeled different variables from our data against it, addressed the goodness of fit of our model,
                       and ultimately have recommendations for our users to increase the social acceptance in their own workplace."),
                tags$p("We have also devised a way to allow the user to explore the dataset on their own, to see what aspects
                       of mental health in the work place might be pertinent for them, and see how much of an effect different
                       aspects have on our three outcomes."),
                tags$p("Ultimately, we want our users to come away with ideas on how mental illness impacts their coworkers, employees and colleagues,
                       with some data driven areas to focus on when fighting the stigma against mental illness in their own office."),
                tags$br(),
                tags$h2("The Data"),
                tags$p("The data used in this analysis comes from a survey conducted by",
                       tags$a(href="https://osmihelp.org/research","Open Sourcing Mental Illness (OSMI)"), "a non profit corporation dedicated 
                       to raising awareness, educating, and providing resources to support mental wellness in the tech and open source communities.
                       They do a survey annually, and we are using the 2014 survey for this project."),
                tags$p("We also found the data from this survey on", 
                       tags$a(href="https://www.kaggle.com/osmi/mental-health-in-tech-survey", "Kaggle.com,"), " which is where we actually sourced our data from because Kaggle had neatly renamed and documented the cumbersome original columns."),
                tags$p("The data itself contained demographic information about the participant, and the answers to their questions from the survey.
                       You can see the questions, and their respective encodings, on the exploration page. One of the questions that stood out to us
                       was 'If you have a mental illness, to what extent would you say it has interfered with your work?' We found this interesting because
                       no where in the survey does it ask directly if a participant has a mental illness, but this question is prety revealing. So we decided that
                       we would analyse the data in three different sets - the full dataset, which included the answers and non answers to that question, and then
                       with two subsets of data: those who indicated having a mental illness, and those who did not. While we cannot firmly say that those who did not answer
                       definitely do not have a mental illness, it has allowed us to see the differing levels of significance in different covariates 
                       depending on the data we use."),
                tags$br(),
                tags$h2("Measuring Social Acceptance"),
                tags$p("We also had to compute our own measures of social acceptance. We actually decided to compute three outcomes of interest to properly address
                       how mental health is percieved and dealt with in the workplace, with social acceptance being one of them. We also computed
                       an ease of communication score, indating how easy it is for someone to communicate with their coworkers and boss about mental health, and
                       an ease of access score, which we calculated based on how transparent a company was about mental health resources offered. All
                       of these measures were calculated based on a variety of variables in the data, and placed on a binary scale, with a 1 indicating that
                       the participant had social acceptance/ease of access/ease of communication at their office, and 0 being that they did not."),
                tags$p("We then used logarithmic regression to evaluate the significance of each covariate in predicting each binary outcome that we had calculated.
                       On the Exploration tab you can interact with all of the aspects of our data described here to see what the p-values generated from our model
                       indicate about the influence of chosen covariates on the outcome of your choice. You can also check the goodness of fit of your model
                       using the ROC plot that is generated. On our Analysis tab you can see what we found to be the best models for each outcome, 
                       and our Recommendations has our suggestions on how to make mental health more accepted in your own workplace."),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br()
              )
            ),
            tabPanel("Explore",
              sidebarLayout(
                sidebarPanel(
                  radioButtons("selectData", label = h3("Select your data of interest"), 
                                     choices = list("Full Data" = 1, "Indicated Mental Illness" = 2, "Did Not Indicate Mental Illness" = 3),
                                     selected = 1 )
                  ,
                  radioButtons("selectOutcome", label = h3("Select your outcome of interest"), 
                                   choices = list("Social Acceptance" = 1, "Ease of Communication" = 2, "Ease of Access" = 3),
                                   selected = 1)
                  ,
                  checkboxGroupInput("selectCovariates", label = h3("Select your covariates of interest"), 
                                    c(covariates),
                                    selected = "self_employed")
                  ),
                       
                  mainPanel(
                    tags$h1("Interactive Regression Tool"),
                    plotlyOutput("plot"),
                    plotOutput("fit"),
                    tags$h2("Covariate Encodings"),
                    tags$p("This chart simply shows what questions each covariate represents.")
                  )
            )),
            tabPanel("Analysis",
              mainPanel(
                tags$h1("Our Analysis"),
                tags$h2("Data Cleaning"),
                tags$p("When we originally procured the data, the first thing we did was trim responses out to just the ones we needed. There was an area for 
                       comments by the respondant that we removed, and we also removed country and state level data because of the large number of non
                       responses. We had hoped to continue using age as a covaritate, but there were also a large number of non responses as well as responses
                       that didn't make sense (extremely high numbers, negative values, and extremely small numbers)."),
                tags$p("We then went about encoding all of the remaining responses into numeric values. We did this so we could easily
                       calculate our outcomes of interest and run regressions of the data. You can see our encoding scheme below."),
                
                dataTableOutput("encodings"),
                
                tags$p("We also decided to coerce some responses. These desicions were context based, for example, there were NA responses to the 
                       'Are you self employed?' question. Because there were only about 10 non responses, we determined that these respondants were NOT self employed,
                       because they indicated working at large companies in the 'How many employees does your company have?' question. Some questions, for example,
                       'Has your employer ever discussed mental health as part of an employee wellness program?' had the responses of 'yes', 'no', and 'don't know'. Due to the 
                      nature of the question, we were able to encode the 'dont' know' responses as 'no' responses, because if you had never experienced a mental health dicussion
                       then your response could equally be no or don't know."),
                tags$h2("Calculating Outcomes of Interest"),
                tags$p("Using the schema below we calculated a binary outcome to represent the social acceptance, ease of communication, and ease of acccess for mental health in the workplace.
                       You can see that if a response contained certain responses that it was categorized as having the outcome, and if it failed on any one of the responses we were looking at,
                       it was categorized as not having that outcome. This simple approach was taken in order to allow us to consider all three outcomes without using wildly different methods
                       of arriving at those outcomes, so we could compare our results of those models."),
                tags$p("SCHEME HERE"),
                tags$h2("The Model"),
                tags$p("For this project we decided to do a log regression, which is a fairly standard way to model binary outcomes like our calculated outcomes of interest. For this analysis it was not 
                       critical for us to select a p value threshold because we were looking at the effects of both singular covariates as well as combinations. Our final model choices were based on a combination
                       of contextual choices (what covariates intuitively work well together), the goodness of fit of the ROC curve, and then the resulting p values from the model."),
                tags$h2("Goodness of Fit"),
                tags$p("an explanation of how we tested the goodness of fit of our models and why we chose ROC"),
                tags$h2("Answering the Question"),
                tags$p("The following are the covariates we determined to have the biggest effect on our outcomes of interest for this analysis."),
                tags$h3("The Model: Ease of Communication"),
                tags$p("here's gonna the be the ease of communcation stuff"),
                tags$h3("The Model: Ease of Access"),
                tags$p("more stuff"),
                tags$h3("The Model: Social Acceptance"),
                tags$p("some more stuff"),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br()
              )
            ),
            tabPanel("Recommendations",
              mainPanel(
                tags$h1("Our Recommendations"),
                tags$p("Based on the covariates we identified in our analysis, we have come up with three concrete measures you can take in your office
                       to increase ease of communication, access to resources, and social acceptance of mental health."),
                tags$h2("Reccommendation One: BLAH"),
                tags$p("write your stuff here"),
                tags$h2("Reccommendation Two: BLAH"),
                tags$p("write your stuff here"),
                tags$h2("Reccommendation Three: BLAH"),
                tags$p("write your stuff here"),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br(),
                tags$br()
              )
            ),
            theme = shinytheme("journal")
       ))
