#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Mental Health in the Workplace",
            tabPanel(
              "Overview",
              mainPanel(
                "This is where we talk about the data"
              )
            ),
            tabPanel("Explore",
              sidebarLayout(
                sidebarPanel(
                  checkboxGroupInput("selectData", label = h3("Select your data of interest"), 
                                     choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                     selected = 1)
                  ,
                  checkboxGroupInput("selectOutcome", label = h3("Select your outcome of interest"), 
                                   choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                   selected = 1)
                  ,
                  checkboxGroupInput("selectCovariates", label = h3("Select your covariates of interest"), 
                                    choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                                    selected = 1)
                  ),
                       
                  mainPanel(
                    fluidRow(column(3, verbatimTextOutput("data"))),
                    fluidRow(column(3, verbatimTextOutput("outcome"))),
                    fluidRow(column(3, verbatimTextOutput("covariate")))
                    
                  )
            )),
            tabPanel("Conclusions",
              mainPanel(
                "This is where we draw our conclusions"
              )
            ), inverse=TRUE
       ))