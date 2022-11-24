## BELHEALTH APP
## Date: 27/09/2022

## set up libraries
library(shiny)
library(readr)
library(fontawesome)
library(haven)
library(ggplot2)
library(dplyr)

## helpers

## .. load data
dta <- readRDS("Data/covid19_wave1towave9.rds")

## create aggregated dataset by strata
dta.aggr <- dta %>%
  group_by(wave, hc04, age4, regio) %>%
  summarise(n = n())

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
    icon = icon("info-circle"),
    
    HTML("<h1 style='color:#69aa41;'>Belgian National Burden of Disease Study</h1>"),
    HTML("<p>What are the most important diseases in Belgium? Which risk factors contribute most to the overall disease burden? How is the burden of disease evolving over time, and how does it differ across the country? In a context of increasing budgetary constraints, a precise answer to these basic questions is more than ever necessary to inform policy-making.</p>"),
    HTML("<p>To address this need, <b>Sciensano</b> is conducting a <b>national burden of disease study</b>. In addition to generating internally consistent estimates of death rate (mortality) or how unhealthy we are (morbidity) by age, sex and region, the burden of disease will also be quantified using Disability-Adjusted Life Years (DALYs). The use of DALY allows to estimate the years of life lost from premature death and years of life lived with disabilities. It therefore permits a truly comparative ranking of the burden of various diseases, injuries and risk factors.</p>"),
    HTML("<p>For more info, please visit <a href='https://www.sciensano.be/en/projects/belgian-national-burden-disease-study'>https://www.sciensano.be/en/projects/belgian-national-burden-disease-study</a></p>"),
    
    HTML("<h2 style='color:#69aa41;'>BeBOD estimates of the burden of disease</h2>"),
    
    h4("Disability-Adjusted Life Years (DALYs)"),
    p("Disability-Adjusted Life Year (DALYs) are a measure of overall disease burden, representing the healthy life years lost due to morbidity and mortality. DALYs are calculated as the sum of YLLs and YLDs for each of the considered diseases."),
    
    h4("Years Lived with Disability (YLDs)"),
    p("Years Lived with Disability (YLDs) quantify the morbidity impact of diseases. They are calculated as the product of the number of prevalent cases with the disability weight (DW), averaged over the different health states of the disease. The DWs reflect the relative reduction in quality of life, on a scale from 0 (perfect health) to 1 (death). We calculate YLDs using the Global Burden of Disease DWs."),
    
    h4("Years of Life Lost (YLLs)"),
    p("Years of Life Lost (YLLs) quantify the mortality impact of diseases. They are calculated as the product of the number of deaths due to the disease with the residual life expectancy at the age of death. We calculate YLLs using the Global Burden of Disease reference life table, which represents the theoretical maximum number of years that people can expect to live."),
    
    h4("Number of prevalent cases"),
    p("The number of prevalent cases for each disease was calculated based on a variety of Belgian data sources, including the Belgian Cancer Registry, the Intermutualistic Agency, the Belgian Health Interview Survey, the Minimal Clinical Data, the Intego general practice sentinel network, and the European kidney registry (ERA-EDTA)."),
    
    h4("Causes of death"),
    HTML("<p>The number of deaths by cause of death are based on the official causes of death database compiled by Statbel. We first map the ICD-10 codes of the underlying causes of death to the Global Burden of Disease cause list, consisting of 137 unique causes of deaths. Next, we perform a probabilistic redistribution of ill-defined deaths to specific causes, to obtain a specific cause of death for each deceased person. Detailed estimates of causes of death can be explored via <a href='https://burden.sciensano.be/shiny/mortality/'>burden.sciensano.be/shiny/daly/</a>.</p>"),
    
    HTML("<h2 style='color:#69aa41;'>Explore our estimates</h2>"),
    
    HTML("<h4><i class='fa fa-th-large'></i>&nbsp; Treemap</h4>"),
    p("Explore the main causes of death, years of life lost, cases, years lived with disabilities, and disability-adjusted life years by age, sex, region and year."),
    
    HTML("<h4><i class='fa fa-chart-line'></i>&nbsp; Trends</h4>"),
    p("Explore trends in causes of death, years of life lost, cases, years lived with disabilities, and disability-adjusted life years, by age, sex and region."),
    
    HTML("<h4><i class='fa fa-sort-amount-up'></i>&nbsp; Rankings</h4>"),
    p("Explore ranks in causes of death, years of life lost, cases, years lived with disabilities, and disability-adjusted life years by age, sex, region and year."),
    
    HTML("<h4><i class='fa fa-chart-bar'></i>&nbsp; Patterns</h4>"),
    p("Compare estimates of causes of death, years of life lost, cases, years lived with disabilities, and disability-adjusted life years by age, sex, region and year."),
    
    HTML("<h4><i class='fa fa-database'></i>&nbsp; Results</h4>"),
    p("Explore and download our estimates of causes of death, years of life lost, cases, years lived with disabilities, and disability-adjusted life years."),
    
  ),
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   SOCIO-DMEO #####
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
            c("Age", "Sex", "Region", "Wave")
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
                0:9
              )
          )
        ),
        
        
        
        
        
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30)
      ),
      
      
      ## OUTPUT
      mainPanel(
        plotOutput("sociodemo")
      )
    )
    
  )
  
  
  
  
  
  
  
)

###
# SERVER
###

server <- function(input, output) {
  
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  ##+                   SOCIO-DMEO #####
  ##++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  output$sociodemo <- renderPlot({
    
    if (input$var_sociodemo == "Age") {
      tmp <- dta.aggr
      
      ## subset
      if (input$region_sociodemo != 0) {
        tmp <- subset(tmp, regio == input$region_sociodemo)
      }
      
      if (input$sex_sociodemo != 0) {
        tmp <- subset(tmp, hc04 == input$sex_sociodemo)
      }
      
      if (input$wave_sociodemo != 0) {
        tmp <- subset(tmp, wave == input$wave_sociodemo)
      }
      
      tmp.aggr <- tmp %>%
        group_by(age4) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = age4, y = n), stat = "identity")
      
    } else if (input$var_sociodemo == "Sex") {
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
        group_by(hc04) %>%
        summarise(n = sum(n))
      
      ## plot
      sociodemo <- 
        ggplot(data = tmp.aggr) +
        geom_bar(aes(x = hc04, y = n), stat = "identity")
    }
    
    sociodemo
    
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
