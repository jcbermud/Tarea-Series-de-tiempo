
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# Esta en la carpeta MPST1
library(shiny)
library(shinyDND)
library(shinyTree)
### Prueba 1
shinyUI(fluidPage(
  #Titulo
  titlePanel("Modelado Predictivo y Serie de Tiempo"),
  navbarPage("Barra de menu",
    tabPanel("Cargar datos",
      sidebarLayout(
        sidebarPanel(
            selectInput("archivo","Tipo de archivo",
                        c("Excel","Texto")),
            helpText("Nota: Si es archivo de Excel se elige la hoja"),
            numericInput("hoja","Elegir la hoja",value = 0),
            checkboxInput("header","Cabecera",value = TRUE),
            checkboxGroupInput("separador", "Separador de archivo:",
                               c("Espacio" = " ",
                                 "Tabuladora" = "\t",
                                 "Coma" = ",",
                                 "Punto y coma" = ";")),
           # checkboxGroupInput("decimal", "Separador de decimal:",
           #                     c("Coma" = ",",
           #                      "Punto" = ".")),
            actionButton("cargar","Cargar datos")
        ),#sidebarPanel
        mainPanel(
          tableOutput("datos")
        )# mainPanel        
      )#sidebarLayout       
    ),#tabPanel           
  
    tabPanel("Crear serie",
      sidebarLayout(
        sidebarPanel(
          selectInput("tiposerie","Tipo de serie",
                      c("Diaria","Mensual","Trimestral")),
          numericInput("frecuencia","Frecuencia",value = 12,min = 1),
          numericInput("year","Year",value = 2017, min = 1),
          numericInput("month","Month o Quarterly",value = 01,min = 01),
          textInput("nombre","Nombre de la serie"),
          textInput("ejex","Nombre del eje x"),
          textInput("ejey","Nombre del eje y"),
          actionButton("crearserie","Crear serie")
        ),#sidebarPanel1
        mainPanel(
          plotOutput("tsdisplay"),
          h4("crear"),
          verbatimTextOutput("crear")
        )#mainPanel1
      )#sidebarLayout1          
    ),#tabPanel1
    
    tabPanel("Analisis Descriptivo",
      sidebarLayout(
        sidebarPanel(
          numericInput("infe","Limite inferior", value = 0),
          numericInput("supe","Limite superior", value = 0),
          numericInput("long","Longitud",value = 1, min = 1),
          selectInput("transformar", "Transformar serie",
                      c("No transformar","Logaritmo","Raiz cuadrada")),
          textInput("nombre1","Nombre de la serie"),
          textInput("ejex1","Nombre del eje x"),
          textInput("ejey1","Nombre del eje y"),
          selectInput("seasona", "Tipo de serie",
                      c("additive","multiplicative"))
          
        ),#sidebarPanel2
        mainPanel(
          h4("summary"),
          verbatimTextOutput("summary"),
          h4("boxcox"),
          verbatimTextOutput("boxcox"),
          plotOutput("gboxcox"),
          plotOutput("transformar"),
          plotOutput("decompose")
        )#mainPanel2
      )#sidebarLayout2
    ),#tabPanel2 
    
    tabPanel("Medias Moviles",
      sidebarLayout(
        sidebarPanel(
          numericInput("order","orden Media movil", value = 1)
         
                 
        ),#sidebarPanel3
        mainPanel(
          # h4("boxcox"),
          # verbatimTextOutput("boxcox"),
           plotOutput("ma")
           
         )#mainPanel3
      )#sidebarLayout3
    )#tabPanel3
  )#navbarPage
))#shinyUI
