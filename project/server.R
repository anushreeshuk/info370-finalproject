#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
healthy <- read.csv("./data/healthy_data.csv")
illness <- read.csv("./data/illness_data.csv")
data <- read.csv("./data/clean_data.csv")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$data <- renderPrint({
    if(input$selectData == 1){
      data
    } else if(input$selectData == 2){
      healthy
    } else if(input$selectData == 3){
      illness
    }
  })
  
  
  output$outcome <- renderPrint({
    if( input$selectOutcome == 1){
      data$social_acceptance
    } else if( input$selectOutcome == 2){
      data$obs_consequence
    } else if( input$selectOutcome == 3){
      "hahahahaha"
    }
  })
  
  
  output$covariate <- renderPrint({ input$selectCovariates })
  
})
