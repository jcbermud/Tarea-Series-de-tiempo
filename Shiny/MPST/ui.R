
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyDND)
library(shinyTree)
### Prueba 1
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
            helpText("Nota: Es un archivo de excel"),
            selectInput("archivo1","Tipo de archivo",
                             c("xlsx")),
            numericInput("hoja","Elija la hoja", value = 0),
            actionButton("boton1","Cargar archivo")
                   
          ), #sidebarPanel1
          mainPanel(
             tableOutput("datos1")  
          )#mainPanel1
        )#sidebarLayout1     
      ),#tabPanel1
      
      tabPanel("Archivo de csv",
               sidebarLayout(
                 sidebarPanel(
                   checkboxInput("header","Cabecera",value = TRUE),
                   checkboxGroupInput("separador", "Separador de archivo:",
                                      c("Espacio" = " ",
                                        "Tabuladora" = "\t",
                                        "Coma" = ",",
                                        "Punto y coma" = ";")),
                   helpText("Nota: Es un archivo de excel csv o txt"),
                   selectInput("archivo2","Tipo de archivo",
                               c("csv")),
                   actionButton("boton2","Cargar archivo")
                   
                 ), #sidebarPanel2
                 mainPanel(
                   tableOutput("datos2")  
                 )#mainPanel2
               )#sidebarLayout2
      ),#tabPanel2
      
      
      tabPanel("Archivo sin formato",
               sidebarLayout(
                 sidebarPanel(
                   checkboxInput("header","Cabecera",value = TRUE),
                   checkboxGroupInput("separador", "Separador de archivo:",
                                      c("Espacio" = " ",
                                        "Tabuladora" = "\t",
                                        "Coma" = ",",
                                        "Punto y coma" = ";")),
                   helpText("Nota: Es un archivo de excel csv o txt"),
                   selectInput("archivo3","Tipo de archivo",
                               c("scan")),
                   actionButton("boton3","Cargar archivo")
                   
                 ), #sidebarPanel3
                 mainPanel(
                   tableOutput("datos3")  
                 )#mainPanel3
               )#sidebarLayout3
      )#tabPanel3
      
    ),#navbarMenu hasta aca van la lectura de archivos
    
    ##### Creacion de la serie
    navbarMenu("Crear serie",
      tabPanel("Diaria",
        sidebarLayout(
          sidebarPanel(
            selectInput("tiposerie","Tipo de serie",
                                     c("Diaria")),
            selectInput("procedencia","Procedencia de los datos",
                        c("txt","xlsx","csv","scan")),
            actionButton("serie","Crear serie"),
            textInput("nombre","Nombre de la serie"),
            textInput("ejex","Nombre del eje x"),
            textInput("ejey","Nombre del eje y")
            
          ),#sidebarPanel
          mainPanel(
                  plotOutput("plot"),
                  plotOutput("acf"),
                  plotOutput("pacf"),
                  h4("serie"),
                  verbatimTextOutput("serie")
          )#mainPanel
        )#sidebarLayout         
      ),#tabPanel
      
      tabPanel("Mensual",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("tiposerie1","Tipo de serie",
                               c("Mensual")),
                   selectInput("procedencia1","Procedencia de los datos",
                               c("txt","xlsx","csv","scan")),
                   numericInput("frecuencia","Frecuencia",value = 12),
                   numericInput("year","Year",value = 2017),
                   numericInput("month","Month",value = 01),
                   actionButton("serie1","Crear serie"),
                   textInput("nombre","Nombre de la serie"),
                   textInput("ejex","Nombre del eje x"),
                   textInput("ejey","Nombre del eje y")
                   
                 ),#sidebarPanel
                 mainPanel(
                   plotOutput("plot1"),
                   plotOutput("acf1"),
                   plotOutput("pacf1"),
                   h4("serie1"),
                   verbatimTextOutput("serie1")
                 )#mainPanel1
               )#sidebarLayout1         
      ),#tabPanel1
      
      tabPanel("Trimestral",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("tiposerie2","Tipo de serie",
                               c("Trimestral")),
                   selectInput("procedencia2","Procedencia de los datos",
                               c("txt","xlsx","csv","scan")),
                   numericInput("frecuencia","Frecuencia",value = 4),
                   numericInput("year","Year",value = 2017),
                   numericInput("quarterly","Quarterly",value = 01),
                   actionButton("serie2","Crear serie"),
                   textInput("nombre","Nombre de la serie"),
                   textInput("ejex","Nombre del eje x"),
                   textInput("ejey","Nombre del eje y")
                   
                 ),#sidebarPane2
                 mainPanel(
                  plotOutput("plot2"),
                  plotOutput("acf2"),
                  plotOutput("pacf2"),
                  h4("serie2"),
                  verbatimTextOutput("serie2")
                 )#mainPanel2
               )#sidebarLayout2
      )#tabPanel2
    
    ),#navbarMenu1
    
    #### analisis descriptivo de la serie
    tabPanel("Analisis Descriptivo de la Serie",
      sidebarLayout(
        sidebarPanel(
          selectInput("tiposerie3","Tipo de serie",
                      c("Diaria","Mensual","Trimestral")),
          selectInput("transformar","Tipo de transformacion",
                      c("No trasnformar","Logaritmo","Raiz cuadrada")),
          selectInput("diferencia","Diferenciar serie",
                      c("diferenciar","no diferenciar")),
          numericInput("diferencia","Orden de diferencia", value = 0)
        ),#sidebarPanelADS
        mainPanel(
          h4("summary"),
         verbatimTextOutput("summary"),
          h4("boxco"),
          verbatimTextOutput("boxcox"),
          plotOutput("seasonal"),
          plotOutput("tsdisplay")
    
    
        )#mainPanelADS
      )#sidebarLayoutADS
    )#tabPanelADS
  )#navbarPage
))#shinyUI
