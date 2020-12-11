  #
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
  
library(shiny)
library(CrisisAfrica)
library(tidyverse)
library(corrplot)
library(cowplot)
library(MASS)
data <- read.csv("/home/ndoye/M1_SSD/Projet_R/Shiny_projet_R/data/african_crises(1).csv")
data <- cleandata(data)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
    # Application title
    titlePanel("Statistique descriptive"),
    selectInput("sI",label = "function",choices = ls("package:CrisisAfrica")),
    selectInput("sIV",label = "type de plot",choices = c("Visualisation1","Visualisation2",
                                                         "Visualisation3","Visualisation4"
                                                         ,"Visualisation5","Visualisation6","Visualisation7")),
    verbatimTextOutput("summary"),
    tableOutput("table"),
    plotOutput("descriptive"),
    verbatimTextOutput("sortie")
 
    
)

server <- function(input, output,session) {
    output$summary <- renderPrint({
        if(input$sI =="cleandata"){
            summary(cleandata(data))
        }
       else if(input$sI=="loaddata"){
         if (exists("data")){
           print("les données data ont été chargé avec succes")
         }
       }
    })
    output$table <- renderTable({
        if(input$sI=="readdata"){
            readdata(data)
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
        else if(input$sI == "crisislm"){
            crisislm(data)
        }
        else if(input$sI == "correlation"){
            correlation(data)
        }
    })
    output$sortie <- renderPrint({
      if(input$sI=="crisislm"){
        crisislm(data)
      }
      else if(input$sI=="correlation"){
        correlation(data)
      }
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)
