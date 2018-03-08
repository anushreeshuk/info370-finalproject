#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#necessary packages and libraries
library(shiny)
library(plotly)
source("regressionFunctionsForShiny.R")
source("bestfit.R")

#data being used in the project
healthy <- read.csv("./data/healthy_data.csv")
illness <- read.csv("./data/illness_data.csv")
data <- read.csv("./data/clean_data.csv")


# Define server logic required to draw a bar plot of p values and an ROC chart
# inludes basic error handling where an empty plot is returned if there is no input

shinyServer(function(input, output) {
    
  output$plot <- renderPlotly({ 
    
    if(input$selectData == 1){
      dataFrame <- data
    } else if(input$selectData == 2){
      dataFrame <- illness
    } else if(input$selectData == 3){
      dataFrame <- healthy
    }
    
    if( input$selectOutcome == 1){
      outcome <- "social_acceptance"
    } else if( input$selectOutcome == 2){
      outcome <- "obs_consequence"
    } else if( input$selectOutcome == 3){
      outcome <- "care_accessibility"
    }
    
    pVals <- getPVals(dataFrame, input$selectCovariates, outcome)
    if( pVals == 1){
      plotly_empty()
    } else {
      createHistogram(pVals)
    }
    
  })
  
  output$fit <- renderPlot({
    if(input$selectData == 1){
      dataFrame <- data
    } else if(input$selectData == 2){
      dataFrame <- illness
    } else if(input$selectData == 3){
      dataFrame <- healthy
    }
    
    if( input$selectOutcome == 1){
      outcome <- "social_acceptance"
    } else if( input$selectOutcome == 2){
      outcome <- "obs_consequence"
    } else if( input$selectOutcome == 3){
      outcome <- "care_accessibility"
    }
    
    model <- create_glm_model(input$selectCovariates, dataFrame, outcome)
    
    if( model == "error"){
      plotly_empty()
    } else {
      draw_best_fit(model, input$selectCovariates, dataFrame, outcome)
    }
    
  })
  
})
