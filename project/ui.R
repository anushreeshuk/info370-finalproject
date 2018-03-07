#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


#install.packages("plotly")
#install.packages("shinythemes")

library(shiny)
library(plotly)
library(shinythemes)

healthy <- read.csv("./data/healthy_data.csv")
illness <- read.csv("./data/illness_data.csv")
data <- read.csv("./data/clean_data.csv")

data <- data %>% select(-X, -Country, -state, -social_acceptance, -ease_communication, -care_accessibility, -work_interfere)

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
                       You can see the questions, and their respective encodings, at the bottom of the page here. One of the questions that stood out to us
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
                       indicate about the influence of chosen covariates on the outcome of your choice. On our Analysis tab you can see what we found to be interesting
                       from the dataset, as well as suggestions on how to make mental health more accepted in your own workplace.")
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
                    plotlyOutput("plot"),
                    plotOutput("fit")
                  )
            )),
            tabPanel("Analysis",
              mainPanel(
                tags$h1("Our Analysis"),
                tags$h2("Data Cleaning"),
                tags$p("data cleaning explanation"),
                tags$h2("Calculating Outcomes of Interest"),
                tags$p("simple visual & explanation of what covariates are in each outcome"),
                tags$h2("The Model"),
                tags$p("An explanation of why we chose to do a log regression, what threshold of p values we are using and how we're using them to answer our question"),
                tags$h2("Goodness of Fit"),
                tags$p("an explanation of how we tested the goodness of fit of our models and why we chose ROC"),
                tags$h2("Answering the Question"),
                tags$p("An explanation how how we went about chosing covariates based on our exploratory tool and contextual information"),
                tags$h3("The Model: Ease of Communication"),
                tags$p("here's gonna the be the ease of communcation stuff"),
                tags$h3("The Model: Ease of Access"),
                tags$p("more stuff"),
                tags$h3("The Model: Social Acceptance"),
                tags$p("some more stuff")
              )
            ),
            tabPanel("Recommendations",
              mainPanel(
                tags$h1("Our Recommendations"),
                tags$p("Based on the covariates we identified in our analysis, we have come up with three concrete measures you can take in your office
                       to increase ease of communication, access to resources, and social acceptance of mental health."),
                tags$h2("Reccommendation One: BLAH"),
                tags$h2("Reccommendation Two: BLAH"),
                tags$h2("Reccommendation Three: BLAH")
              )
            ),
            theme = shinytheme("journal")
       ))