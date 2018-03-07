#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
healthy <- read.csv("./data/healthy_data.csv")
illness <- read.csv("./data/illness_data.csv")
data <- read.csv("./data/clean_data.csv")
x <- source("regressionFunctionsForShiny.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$plot <- renderPlotly({ 
    #covariates <- c("Gender")
   # metrics <- "social_acceptance"
    
    if(input$selectData == 1){
      dataFrame <- data
    } else if(input$selectData == 2){
      dataFrame <- healthy
    } else if(input$selectData == 3){
      dataFrame <- illness
    }
    
    if( input$selectOutcome == 1){
      outcome <- "social_acceptance"
    } else if( input$selectOutcome == 2){
      outcome <- "obs_consequence"
    } else if( input$selectOutcome == 3){
      outome <- "care_accessibility"
    }
    
    print(input$selectCovariates)
    
    plotPValues(dataFrame, input$selectCovariates, outcome) 
    
  })
  
})
