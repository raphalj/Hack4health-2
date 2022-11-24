## BELHEALTH APP
## Date: 27/09/2022

## set up libraries
#install.packages("shiny")
#install.packages("readr")
#install.packages("fontawesome")
#install.packages("haven")
#install.packages("ggplot2")
#install.packages("dplyr")


library(shiny)
library(readr)
library(fontawesome)
library(haven)
library(ggplot2)
library(dplyr)
library (haven)
## helpers

# import the data
belhealth_wave1_final <- read_sas("./belhealth_wave1_final.sas7bdat")

## create aggregated dataset by strata
belhealth.aggr <- belhealth_wave1_final %>%
  group_by(SD02a, age4n, regio) %>%
  summarise(n = n())

belhealth.aggr[belhealth.aggr$age4n == 1,"age4n_char"] <- "18 - 29 y"
belhealth.aggr[belhealth.aggr$age4n == 2,"age4n_char"] <- "30 - 49 y"
belhealth.aggr[belhealth.aggr$age4n == 3,"age4n_char"] <- "50 - 64 y"
belhealth.aggr[belhealth.aggr$age4n == 4,"age4n_char"] <- "65+ y"

belhealth.aggr <- belhealth.aggr %>%
  ungroup() %>%
  mutate(pop_sum = sum(n))

belhealth.aggr <- belhealth.aggr %>%
  ungroup() %>%
  mutate(pop_sum = sum(n),
         pop_perc = (n/pop_sum)*100)

## APP

###
# UI
###

ui <- navbarPage(
  
  #### HEADER ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  title =
    HTML(
      "<a href='https://www.sciensano.be'><img src='sciensano.png' height='20px'></a>&nbsp;&nbsp;&nbsp; <span style='color:#69aa41; font-size:1.1em;'>BELHEALTH<span>"
    ),
  windowTitle = "BELHEALTH",
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   INFO #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  tabPanel(
    "Info",
    #icon = icon("info-circle"),
    
    HTML("<h1 style='color:#69aa41;'>Belgian Health and Wellbeing Cohort</h1>"),
    HTML("<p>The BELHEALTH epidemiological cohort is a longitudinal study in the general population based on repeated surveys of a representative sample of adults in Belgium. It aims to monitor the evolution of health and wellbeing in the post-COVID period and to identify vulnerability factors for health and quality of life of individuals. Although the Covid-19 pandemic is becoming less of a threat, we face new challenges with profound social and economic consequences for the population. It is therefore essential to ensure continuous monitoring of the health and well-being of citizens in order to guide prevention policies, strengthen social resilience, and invest in adequate structural support.</p>"),
    HTML("<p>For more info, please visit <a href='https://www.sciensano.be/en/projects/belgian-health-and-well-being-cohort'>https://www.sciensano.be/en/projects/belgian-health-and-well-being-cohort</a></p>"),
    #tags$iframe(width="560", height="315", src="https://www.youtube.com/watch?v=ibL2jVfV9YA", frameborder="0", allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture", allowfullscreen=NA),
  ),
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   SOCIO-DEMO #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  tabPanel(
    title = "Socio-demo",
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h3("Chart settings", style = "color:#69aa41;"),
        
        ## select variable
        selectizeInput(
          inputId = "var_sociodemo",
          label = "Variable", 
          choices = 
            c("Age", "Sex", "Region", "Wave", "Education", "Householdtype", "Occupation")
        ),
        
        ## filter dataset by
        h3("Filter by:"),
        
        conditionalPanel(
          condition = "input.var_sociodemo != 'Region'",
          
          selectizeInput(
            inputId = "region_sociodemo",
            label = "Region",
            choices = 
              list(
                "Belgium" = 0,
                "Brussels" = 2,
                "Flanders" = 1,
                "Wallonia" = 3)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Sex'",
          
          selectizeInput(
            inputId = "sex_sociodemo",
            label = "Sex",
            choices = 
              list(
                "Both sexes" = 0,
                "Female" = 2,
                "Male" = 1)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Age'",
          
          selectizeInput(
            inputId = "age_sociodemo",
            label = "Age",
            choices = 
              list(
                "All Ages" = 0,
                "18-30" = 1,
                "31-45" = 2,
                "46-65" = 3,
                "65+" = 4)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Wave'",
          
          selectizeInput(
            inputId = "wave_sociodemo",
            label = "Wave",
            choices = 
              c(
                0:1
              )
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Education'",
          
          selectizeInput(
            inputId = "education_sociodemo",
            label = "Education",
            choices = 
              list(
                "All" = 0,
                "Low educated" = 1,
                "High educated" = 2
              )
          )
        )
        
        
      ),
      mainPanel (plotOutput("sociodemo"))
    ) 
  ),
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   RESULTS #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  tabPanel(
    title = "Results",
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      sidebarPanel(
        width = 3,
        h3("Chart settings", style = "color:#69aa41;"),
        
        ## select variable
        selectizeInput(
          inputId = "var_results",
          label = "Variable", 
          choices = 
            c("Depression", "Anxiety", "Life satisfaction","Social unsatisfaction", "Wave")
        ),
        
        ## filter dataset by
        h3("Filter by:"),
        
        conditionalPanel(
          condition = "input.var_results != 'Region'",
          
          selectizeInput(
            inputId = "region_sociodemo",
            label = "Region",
            choices = 
              list(
                "Belgium" = 0,
                "Brussels" = 2,
                "Flanders" = 1,
                "Wallonia" = 3)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Sex'",
          
          selectizeInput(
            inputId = "sex_sociodemo",
            label = "Sex",
            choices = 
              list(
                "Both sexes" = 0,
                "Female" = 2,
                "Male" = 1)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Age'",
          
          selectizeInput(
            inputId = "age_sociodemo",
            label = "Age",
            choices = 
              list(
                "All Ages" = 0,
                "18-30" = 1,
                "31-45" = 2,
                "46-65" = 3,
                "65+" = 4)
          )
        ),
        conditionalPanel(
          condition = "input.var_sociodemo != 'Wave'",
          
          selectizeInput(
            inputId = "wave_sociodemo",
            label = "Wave",
            choices = 
              c(
                1:2
              )
          )
        )
        
      ),
      
      ## OUTPUT
      mainPanel (plotOutput("results")) # creates a table for the results
      
    )
    
  ),
  
  
  
)



###
# SERVER
###

server <- function(input, output) {
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   SOCIO-DEMO #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  output$sociodemo <- renderPlot({
    
    if (input$var_sociodemo == "Age") {
      tmp <- belhealth.aggr
      
      ## subset
      if (input$region_sociodemo != 0) {
        tmp <- subset(tmp, regio == input$region_sociodemo)
      }
      
      if (input$sex_sociodemo != 0) {
        tmp <- subset(tmp, SD02a == input$sex_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(age4n_char) %>%
        summarise(n = n())
      
      ## plot
      sociodemo <- 
        ggplot(data = belhealth.aggr) +
        geom_bar(aes(x = age4n_char, y = pop_perc), stat = "identity")+
        labs(x = 'Age category', y = '% of participants')+
        theme(axis.title.y = element_text(margin = margin(r = 25)))
        
      
    } else if (input$var_sociodemo == "Sex") {
      tmp <- belhealth.aggr
      
      ## subset
      if (input$region_sociodemo != 0) {
        tmp <- subset(tmp, regio == input$region_sociodemo)
      }
      
      if (input$age_sociodemo != 0) {
        tmp <- subset(tmp, age4n == input$age_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(SD02a) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = SD02a, y = n), stat = "identity")
      
    }else if (input$var_sociodemo == "Region") {
      tmp <- belhealth.aggr
      
      ## subset
      if (input$sex_sociodemo != 0) {
        tmp <- subset(tmp, SD02a == input$region_sociodemo)
      }
      
      if (input$age_sociodemo != 0) {
        tmp <- subset(tmp, age4n == input$age_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(regio) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = regio, y = n), stat = "identity")
      
    }
    
    sociodemo
    
  })
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   RESULTS #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  
  
  output$results <- renderPlot({
    
    if (input$var_results == "Depression") {
      tmp <- dta.aggr
      
      ## subset
      if (input$region_sociodemo != 0) {
        tmp <- subset(tmp, regio == input$region_sociodemo)
      }
      
      if (input$sex_sociodemo != 0) {
        tmp <- subset(tmp, SD02a == input$sex_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(AD_6) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = AD_6, y = n), stat = "identity")
      
    } else if (input$var_results == "Anxiety") {
      tmp <- dta.aggr
      
      ## subset
      if (input$region_sociodemo != 0) {
        tmp <- subset(tmp, regio == input$region_sociodemo)
      }
      
      if (input$age_sociodemo != 0) {
        tmp <- subset(tmp, age4 == input$age_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(AD_1) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = AD_1, y = n), stat = "identity")
    }
    
    results
    
  })
  
  
  
  
  # output$distPlot <- renderPlot({
  #     # generate bins based on input$bins from ui.R
  #     x    <- faithful[, 2]
  #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
  # 
  #     # draw the histogram with the specified number of bins
  #     hist(x, breaks = bins, col = 'darkgray', border = 'white',
  #          xlab = 'Waiting time to next eruption (in mins)',
  #          main = 'Histogram of waiting times')
  # })
}

# Run the application 
shinyApp(ui = ui, server = server)
