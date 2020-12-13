  #
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
  
library(shiny)
library(shinyjs)
library(shinythemes)
library(CrisisAfrica)
library(tidyverse)
library(corrplot)
library(cowplot)
library(MASS)
library(knitr)

data <- read.csv("data/african_crises.csv")
# datac: les données nettoyées
datac <- CleanData(data)
# Define UI for resume our project
ui <- navbarPage(theme= shinytheme("readable"),
                 title = img(src="ugalogo.jpg", height = "40px",align="center"), id = "navBar",
                 tabPanel("Statistique descriptive",
                          selectInput("sI",label = "Les fonctions",choices = ls("package:CrisisAfrica")),
                          conditionalPanel(
                            condition = "input.sI == 'Visualisation'",
                            selectInput("sIV",label = "type de visualisation",choices = c("Visualisation1","Visualisation2",
                                                                                          "Visualisation3","Visualisation4"
                                                                                          ,"Visualisation5"
                                                                                           ,"Visualisation6","Visualisation7"))
                          ),
                      
                              
                              tableOutput("table"),
                              verbatimTextOutput("summary"),
                              plotOutput("descriptive"),
                              verbatimTextOutput("sortie") 
                 ), 
                 tabPanel("Analyse et interpretation",
                          # Conversion d'un fichier Rmarkdown en markdown
                          rmdfiles <- c("projetb.Rmd"),
                          sapply(rmdfiles, knit, quiet = T),
                          withMathJax(includeMarkdown("projetb.md"))
                            
                  ),
                 tabPanel("Presentation du groupe",
                          includeHTML("about.html"),
                          shinyjs::useShinyjs(),
                          tags$head(
                            tags$link(rel = "stylesheet", 
                                      type = "text/css", 
                                      href = "plugins/carousel.css"),
                            tags$script(src = "plugins/holder.js")
                          ),
                          tags$style(type="text/css",
                                     ".shiny-output-error { visibility: hidden; }",
                                     ".shiny-output-error:before { visibility: hidden; }")
                          
                 )
                 
)
# partie server
server <- function(input, output,session) {
  output$table <- renderTable({
    if(input$sI=="ReadData"){
      r <- ReadData(data)
      r[1]
    }
  })
  output$summary <- renderPrint({
        if(input$sI =="CleanData"){
          summary(CleanData(data))
        }
        else if(input$sI=="ReadData"){
          r <- ReadData(data)
          r[2]
        }
    })
    output$descriptive <- renderPlot({
            if(input$sI == "Visualisation"){
                  v <- Visualisation(datac)
                  if(input$sIV=="Visualisation1"){
                    v[1]
                  }
                  else if(input$sIV=="Visualisation2"){
                    v[2]
                  }
                  else if(input$sIV=="Visualisation3"){
                    v[3]
                  }
                  else if(input$sIV=="Visualisation4"){
                    v[4]
                  }
                  else if(input$sIV=="Visualisation5"){
                    v[5]
                  }
                  else if(input$sIV=="Visualisation6"){
                    v[6]
                  }
                  else if(input$sIV=="Visualisation7"){
                    v[7]
                  }
             }
        else if(input$sI == "RegressionLineaire"){
          RegressionLineaire(datac)
        }
        else if(input$sI == "Correlation"){
            Correlation(datac)
        }
    })
    output$sortie <- renderPrint({
      if(input$sI=="RegressionLineaire"){
        RegressionLineaire(datac)
      }
      else if(input$sI=="Correlation"){
        Correlation(datac)
      }
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)

