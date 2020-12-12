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
data <- read.csv("data/african_crises.csv")
data <- CleanData(data)

# Define UI for resume our project
ui <- navbarPage(theme= shinytheme("readable"),
                 title = img(src="ugalogo.jpg", height = "40px",align="center"), id = "navBar",
                 tabPanel("Statistique descriptive",
                          selectInput("sI",label = "Les fonctions",choices = ls("package:CrisisAfrica")),
                              selectInput("sIV",label = "type de visualisation",choices = c("Visualisation1","Visualisation2",
                                                                                   "Visualisation3","Visualisation4"
                                                                                   ,"Visualisation5"
                                                                                   ,"Visualisation6","Visualisation7")),
                      
                              verbatimTextOutput("summary"),
                              tableOutput("table"),
                              plotOutput("descriptive"),
                              verbatimTextOutput("sortie")
                 ), 
                 tabPanel("Analyse et interpretation",
                          includeMarkdown("projetb.Rmd")  
                            
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

server <- function(input, output,session) {
    output$summary <- renderPrint({
        if(input$sI =="CleanData"){
            summary(CleanData(data))
        }
       else if(input$sI=="LoadData"){
         if (exists("data")){
           print("les données data ont été chargé avec succes")
         }
       }
    })
    output$table <- renderTable({
        if(input$sI=="ReadData"){
            ReadData(data)
        }
    })
    
    output$descriptive <- renderPlot({
            if(input$sI == "Visualisation"){
                  v <- Visualisation(data)
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
          RegressionLineaire(data)
        }
        else if(input$sI == "Correlation"){
            Correlation(data)
        }
    })
    output$sortie <- renderPrint({
      if(input$sI=="RegressionLineaire"){
        RegressionLineaire(data)
      }
      else if(input$sI=="Correlation"){
        Correlation(data)
      }
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)

