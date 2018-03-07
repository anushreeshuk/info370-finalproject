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
source("regressionFunctionsForShiny.R")
source("bestfit.R")

# Define server logic required to draw a histogram
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
    
    createHistogram(pVals)
    
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
    
    draw_best_fit(model, input$selectCovariates, dataFrame, outcome)
    
  })
  
})
