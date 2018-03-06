#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


# Define UI for application that draws a histogram
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
                tags$br(),
                tags$h2("Measuring Social Acceptance"),
                tags$p("")
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
                                   choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                   selected = 1)
                  ,
                  checkboxGroupInput("selectCovariates", label = h3("Select your covariates of interest"), 
                                    choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                    selected = 1)
                  ),
                       
                  mainPanel(
                    fluidRow(column(6, verbatimTextOutput("data"))),
                    fluidRow(column(6, verbatimTextOutput("outcome"))),
                    fluidRow(column(6, verbatimTextOutput("covariate")))
                    
                  )
            )),
            tabPanel("Conclusions",
              mainPanel(
                "This is where we draw our conclusions"
              )
            ), theme = shinytheme("journal")
       ))