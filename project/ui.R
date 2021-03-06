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
                    tags$p("This chart simply shows what questions each covariate represents."),
                    tableOutput("definitions")
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
                tags$div(class="card text-white bg-secondary mb-3", style="max-width: 50rem; background-color:lavender; text-align:center",
                    tags$div(class="card-body",
                      tags$h4( class="card-title", "Ease of Access"),
                      tags$p(class="card-text", "IF"),
                      tags$p("supervisor > 1 &"),
                      tags$p("(mental_health_interview = 1 OR phys_health_interview = 2) &"),
                      tags$p("(mental_health_consequence = 1 OR cphys_health_consequence = 2)"),
                      tags$p("THEN"),
                      tags$p("ease of access is TRUE")
                    )
                ),
                tags$div(class="card", style="max-width: 50rem; background-color:lavender; text-align:center",
                    tags$div(class="card-body",
                      tags$h4( class="card-title", "Ease of Communication"),
                      tags$p(class="card-text", "IF"),
                      tags$p(class="card-text", "benefits == 1 &"),
                      tags$p("care_options == 1 &"),
                      tags$p("wellness_program == 1 &"),
                      tags$p("seek_help == 1"),
                      tags$p("THEN"),
                      tags$p("ease of communication is TRUE")
                    )
                ),
                tags$div(class="card", style="max-width: 50rem; background-color:lavender; text-align:center",
                   tags$div(class="card-body",
                    tags$h4( class="card-title", "Social Acceptance"),
                    tags$p(class="card-text", "IF"),
                    tags$p(class="card-text", "anonymity == 1 & "),
                    tags$p("(leave == 3 | leave == 4) &"),
                    tags$p("mental_health_consequence == 0 &"),
                    tags$p("supervisor == 1 &"),
                    tags$p("obs_consequence == 0"),
                    tags$p("THEN"),
                    tags$p("social acceptance is TRUE")
                  )
                ),
                tags$h2("The Model"),
                tags$p("For this project we decided to do a log regression, which is a fairly standard way to model binary outcomes like our calculated outcomes of interest. For this analysis it was not 
                       critical for us to select a p value threshold because we were looking at the effects of both singular covariates as well as combinations. Our final model choices were based on a combination
                       of contextual choices (what covariates intuitively work well together), the goodness of fit of the ROC curve, and then the resulting p values from the model."),
                tags$h2("Goodness of Fit"),
                tags$p("Before we can get into the understanding the goodness of fit and ROC Curves, it's important to understand what specificity and sensitivity mean. When doing a predictive analysis, it is almost certain to come across a rate of error. 
                        Manipulating and grasping these values is how data scientists make a living. Sensitivity or the True Positive Rate is the ability for a test to correctly identify true positive values. Whereas specificity measures how often our test incorrestly tests positive or in simple terms how often does it give us a fake scare. 
                        Receiver Operating Characteristic or better know as ROC Curves is a popular technique to visualize the performance of a binary classifier. Since the data we are using has been cleaned to mostly show 0 and 1 values, we decided to follow the ROC approach.
                        For our logistic model, we are plotting the best fit line based on the data, the outcome of interest and the various coovariates that the user selects. 
                        covariates and outcome of interest picks up true positives and minimum false positives. Curves that get closer to the diagonal axis indicate poor model accurancy. Feel free to play around with the tool on the Explore page to get a deeper grasp on these concepts."),
                tags$h2("Answering the Question"),
                tags$p("The following are the covariates we determined to have the biggest effect on our outcomes of interest for this analysis."),
                tags$h3("The Model: Ease of Communication"),
                tags$p("Family_history, leave, and seek_help have the biggest effect on our outcome of interest, ease of communication. The p-values for these covariates 
                       range from essentially 0 to 389mu, which is also essentially 0. This shows a very strong correlation. After finding these covariates of interest,
                       we are able to speculate about why they have an effect on ease of communication. The questions asked were \"Do you have a family history of mental illness?\",
                       \"How easy is it for you to take medical leave for a mental health condition?\", and \"Does your employer provide resources to learn more about 
                       mental health issues and how to seek help?\". These questions seem to be fairly intuitive in the relation to ease of communication - perhaps because the subject
                       has family history of mental health ilness, they know of resoures and feel more comfortable discussing the fact. Additionally, if an employer provides 
                       mental health resources and it is easy to take medical leave because of a mental health condition, the subject may become more common and less 
                       personal in the workplace, allowing the subject to talk freely about mental health."),
                plotlyOutput("communication"),
                  
                tags$h3("The Model: Ease of Access"),
                tags$p("Treatment, no_employee, and anonymity have the biggest effect on our outcome of interest, ease of access to mental health care.
                       The p-values for these covariates range from essentially 0 to 0.027, which show a strong correlation. The questions asked were \"Have you 
                       sought treatment for a mental health condition?\", \"How many employees does your company or organization have?\", and \"Is your anonymity 
                       protected if you choose to take advantage of mental health or substance abuse treatment resources?\". Some of these questions intuitivly make sense
                       immediately - anonymity provides privacy and so subjects may feel safer to access mental health care. If the subject has already sought treatment for
                       a mental health condition, they will be more familiar with attaining the help they desire. Number of employees seems the least related to accessing
                       mental health care, but perhaps in a large company, the subject knows more people who have used mental health services and then better understands the 
                       opportunities to gain access to mental health care. On the other hand, if the subject works at a small company, they may be closer with the other 
                       employees and have a more diverse dialogue that includes the subject of mental health."),
                plotlyOutput("access"),
                
                tags$h3("The Model: Social Acceptance"),
                tags$p("Coworkers, leave, supervisor, and obs_consequence have the biggest effect on our outcome of interest, social acceptance of mental health care.
                       The p-values for these covariates range from essentially 0 to 0.98 (observed consequence). This is an extremely high p-value, but it is important to notice 
                       that when the observed consequence is selected as a covariate, the other covariate's p-values decrease significantly - the next highest is coworkers at 0.48.
                       It is likely so high because we used it in our calculation of social acceptance. The questions asked were \"Would you be willing to discuss a mental health issue with your coworkers?\",
                      \"How easy is it for you to take medical leave for a mental health condition?\", \"Would you be willing to discuss a mental health issue with your direct supervisor(s)?\" and
                      \"Have you heard of or observed negative consequences for coworkers with mental health conditions in your workplace?\". The covariates of coworker and supervisor
                       are very relevent to this outcome because they represent the social aspect of the office. Leave plays a role because the coworkers are willing to fill in 
                       for the work you are missing because they understand and accept the needs of mental health conditions. Observed consequence is relevent because it also has to do 
                       with the social aspect of the work environment."),
                plotlyOutput("acceptance"),

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
                
                tags$h2("Reccommendation One: Easing Mental Illness Communication"),
                tags$p("In our 'Ease of Communication' analysis, we found that three covariates `family_history`, `leave`, and `seek_help` had the greatest effect on our
                        outcome of interest. `seek_help` is the most obvious outcome, where subjects answered, 'Does your employer provide resources to learn more about mental
                        health issues and how to seek help?'. Perhaps more interesting was the the correlation between ease of communication and the covariate `family history`, which 
                        asks, 'Do you have a family history of mental illness?' In other words, if an employee has a family history of mental illness, they are likelier to find that 
                        communicating mental illness is substantially easier. While it is obviously not possible to suggest that employee's should have a family history of mental 
                        illness just to improve their ease of communication, we can potentially devise other ways to link these covariates. While providing resources that address 
                        mental illnesses and as well as employee health leave are appropriate reponses, we suggest a hybrid of help resources and family mental illness history
                        changes. Specifically, the employer could introduce material that introduces information about family mental illness history and awareness could prove 
                        effective in easing the communication of said illnesses. Digital media, documentation, and other sources suggesting employees look into family health 
                        history combined with strategica resources for those seeking mental illness help would be an example of this workplace improvement. Ultimately, 
                        this solution can be thought of as a combination of covariates that not only informs employees but also provides awareness of family mental health history 
                        and acceptance."),
                
                tags$h2("Reccommendation Two: Anonymizing and Separating Access to Resources"),
                tags$p("When analyzing our covariates for 'Ease of Access', we found that `treatment`, `no_employee` and `anonymity` have the biggest effect. Anonymity had a surprisingly 
                       large effect on the outcome of interest and we surmise that because employees have anonymity, they might find it more comfortable or even safer to access mental 
                       health care resources. Additionally, an increase in company size also correlates to ease of access - presumably because with more employees, the chance of others 
                       knowing about the employees mental health illness decreases. We are led to believe that there is a stigma in the workplace against illness - specifically mental 
                       illness. While we could suggest the implementation of measures to anonymize employee requests for mental health illness resources, it still would not solve 
                       the problem for companies with a small number of employees (eg. less than 20). Therefore, our recommendation is for companies to not only anonymize the process 
                       of seeking access to mental health care and substance abuse treatment, but also to delegate the response to a third-party, like human resources. Many very small 
                       companies often utilize a third-party HR resource, which could offer employees an anonymous experience but also simulate a large company because there is less 
                       personal health discolsure between HR and other members of the company."),
                tags$h2("Reccommendation Three: Encouraging Leave and Dialogue"),
                tags$p("Finally, our last recommendation for improving workplace mental health is concerned with the outcome of interest, 'Social Acceptance'. 
                       We found that the covariates, `coworkers`, `supervisor`, `leave`, and `obs_consequence` has the greatest effects. While the first two recommendations 
                       above would potentially provide improvements in this outcome of interest as well, we are more concerned with the social impacts of having a mental 
                       illness in the workplace. Therefore, we recommend that employers encourage employees to take leave to tend to their mental health illness and promote communication
                       between the coworkers and supervisors about mental health conditions in order to normalize the dialogue about mental health conditions.Coupled with a policy 
                       of anonymization and the third-party approval system outlined in recommendation two, this would have significant positive impacts on social 
                       acceptance of mental health illness in the workplace."),
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
