
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(forecast)
library(shinyTree)
library(xlsx)
library(stats)
library(MASS)
library(car)
library(plotly)
library(ggplot2)

#shinyUI(fluidPage(

  # Application title
#  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
#  sidebarLayout(
#    sidebarPanel(
#      sliderInput("bins",
#                  "Number of bins:",
#                  min = 1,
#                  max = 50,
#                  value = 30)
#    ),

    # Show a plot of the generated distribution
#    mainPanel(
#      plotOutput("distPlot")
#    )
#  )
#))

## Prueba 1
shinyUI(fluidPage(
  
  #Titulo
  titlePanel("Modelado predictivo y Serie de tiempo"),
  navbarPage("Barra de menu",
    navbarMenu("Cargar de datos",
      tabPanel("Archivo de texto",
        sidebarLayout(
          sidebarPanel(
            checkboxInput("header","Cabecera",value = TRUE),
            checkboxGroupInput("separador", "Separador de archivo:",
                               c("Espacio" = " ",
                                 "Tabuladora" = "\t",
                                 "Coma" = ",",
                                 "Punto y coma" = ";")),
            helpText("Nota: Es un archivo de texto txt"),
            selectInput("archivo","Tipo de archivo",
                        c("txt")),
            actionButton("boton","Cargar archivo")
              
          ), #sidebarPanel
        mainPanel(
         tableOutput("datos")  
        )#mainPanel
        )#sidebarLayout     
      ),#tabPanel   
      
      tabPanel("Archivo de Excel",
               sidebarLayout(
                 sidebarPanel(
                   checkboxInput("header","Cabecera",value = TRUE),
                   checkboxGroupInput("separador", "Separador de archivo:",
                                      c("Espacio" = " ",
                                        "Tabuladora" = "\t",
                                        "Coma" = ",",
                                        "Punto y coma" = ";")),
                   helpText("Nota: Es un archivo de Excel xlsx"),
                   selectInput("archivo","Tipo de archivo",
                               c("xlsx")),
                   helpText("Nota: Elija la hoja es solo para xlsx"),
                   numericInput("hoja","Elija la hoja", value = 0),
                   actionButton("boton","Cargar archivo")
                   
                 ), #sidebarPanel1
                 mainPanel(
                   tableOutput("datos")  
                 )#mainPanel1
               )#sidebarLayou1
      ),#tabPanel1   
      
      tabPanel("Archivo csv",
               sidebarLayout(
                 sidebarPanel(
                   checkboxInput("header","Cabecera",value = TRUE),
                   checkboxGroupInput("separador", "Separador de archivo:",
                                      c("Espacio" = " ",
                                        "Tabuladora" = "\t",
                                        "Coma" = ",",
                                        "Punto y coma" = ";")),
                   helpText("Nota: Es un archivo de Excel csv o de texto csv"),
                   selectInput("archivo","Tipo de archivo",
                               c("csv")),
                   actionButton("boton","Cargar archivo")
                   
                 ), #sidebarPanel2
                 mainPanel(
                   tableOutput("datos")  
                 )#mainPanel2
               )#sidebarLayou2
      ),#tabPanel2   
    
      tabPanel("Archivo scan",
               sidebarLayout(
                 sidebarPanel(
                   checkboxInput("header","Cabecera",value = TRUE),
                   checkboxGroupInput("separador", "Separador de archivo:",
                                      c("Espacio" = " ",
                                        "Tabuladora" = "\t",
                                        "Coma" = ",",
                                        "Punto y coma" = ";")),
                   helpText("Nota: Lee datos dentro de un vector o 
                            lista de la consola o archivo."),
                   selectInput("archivo","Tipo de archivo",
                               c("scan")),
                   actionButton("boton","Cargar archivo")
                   
                 ), #sidebarPanel3
                 mainPanel(
                   tableOutput("datos")  
                 )#mainPanel3
               )#sidebarLayou3
      )#tabPanel3   
      
        
    )#navbarMenu
    
   # navbarMenu("Crear serie",
    #  tabPanel("Diaria",
    #    sidebarLayout(
    #      sidebarPanel(
    #      selectInput("tiposerie","Tipo de serie",
    #                   c("Diaria")),
          #  numericInput("frecuencia","Frecuencia",value = 12),
          #  numericInput("year","Year",value = 2017),
          #  numericInput("month","Month",value = 01),
          #  numericInput("quarterly","Quarterly",value = 01),
     #       actionButton("serie","Crear serie"),
    #        textInput("nombre","Nombre de la serie"),
    #        textInput("ejex","Nombre del eje x"),
    #        textInput("ejey","Nombre del eje y")
    #      ),#sidebarPanel1
    #      mainPanel(
    #        h4("serie"),
    #        verbatimTextOutput("serie"),
    #        plotOutput("plot"),
    #        plotOutput("acf"),
    #        plotOutput("pacf")
    #      )#mainPanel
    #    )#SidebarLayout1
    #  ),#tabPanel1
    #  tabPanel("Mensual",
    #    sidebarLayout(
    #      sidebarPanel(
    #        selectInput("tiposerie","Tipo de serie",
    #                    c("Mensual")),
    #          numericInput("frecuencia","Frecuencia",value = 12),
    #          numericInput("year","Year",value = 2017),
    #          numericInput("month","Month",value = 01),
    #          actionButton("serie","Crear serie"),
    #          textInput("nombre","Nombre de la serie"),
    #          textInput("ejex","Nombre del eje x"),
    #          textInput("ejey","Nombre del eje y")
            
    #      ),#sidebarPanel2
    #      mainPanel(
    #        h4("serie"),
    #        verbatimTextOutput("serie"),
    #        plotOutput("plot"),
    #        plotOutput("acf"),
    #        plotOutput("pacf")
    #      )#mainPanel2
    #    )#sidebarLayout2
    #  )#tabPanel2
    #)#,# navbarMenu
  
      #tabPanel("Analisis Descriptivo de la Serie",
      #  sidebarLayout(
      #    sidebarPanel(
      #      selectInput("transformar","Tipo de transformacion",
      #                  c("No trasnformar","Logaritmo","Raiz cuadrada")),
      #      selectInput("diferencia","Diferenciar serie",
      #                  c("diferenciar","no diferenciar")),
      #      numericInput("diferencia","Orden de diferencia", value = 0)
      #    ),#sidebarPanel
      #    mainPanel(
      #      h4("summary"),
      #     verbatimTextOutput("summary"),
      #      h4("boxco"),
      #      verbatimTextOutput("boxco")
            
            
      #    )#mainPanel2
      #  )#sidebarLayout2
      #)#tabPanel2
  )#navbarPage
))#shinyUI
