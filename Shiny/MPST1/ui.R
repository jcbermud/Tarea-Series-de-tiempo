
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
          numericInput("year","Año",value = 2017, min = 1),
          numericInput("month","Mes o Trimestre",value = 01,min = 01),
          numericInput("lo","Observaciones sin considerar",value = 1),
          textInput("nombre","Nombre de la serie"),
          textInput("ejex","Nombre del eje x"),
          textInput("ejey","Nombre del eje y"),
          actionButton("crearserie","Crear serie")
        ),#sidebarPanel1
        mainPanel(
          plotOutput("tsdisplay"),
          plotOutput("tsdisplayoriginal"),
          h4("crear"),
          verbatimTextOutput("crear"),
          h4("original"),
          verbatimTextOutput("original")
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
          selectInput("dseasonal", "Tipo de serie",
                      c("additive","multiplicative"))
          
        ),#sidebarPanel2
        mainPanel(
          h4("summary"),
          verbatimTextOutput("summary"),
          h4("boxcox"),
          verbatimTextOutput("boxcox"),
          plotOutput("gboxcox"),
          plotOutput("transformar"),
          plotOutput("decompose"),
          plotOutput("boxplot")
        )#mainPanel2
      )#sidebarLayout2
    ),#tabPanel2 
    
    tabPanel("Medias Moviles",
      sidebarLayout(
        sidebarPanel(
          numericInput("order","orden Media movil ma", value = 1),
          textInput("nombre2","Nombre de la serie"),
          textInput("ejex2","Nombre del eje x"),
          textInput("ejey2","Nombre del eje y")
                 
        ),#sidebarPanel3
        mainPanel(
          # h4("boxcox"),
          # verbatimTextOutput("boxcox"),
           plotOutput("ma")
           
         )#mainPanel3
      )#sidebarLayout3
    ),#tabPanel3
    
    tabPanel("Holt-Winter",
             sidebarLayout(
               sidebarPanel(
                 helpText("Nota: Si Beta = FALSE y Gamma = FALSE es un suavisamiento exponencial simple"),
                 numericInput("alpha","Alpha", value = 0),
                 checkboxInput("beta","Modelar tendencia Beta", value = FALSE),
                 numericInput("bet","Beta", value = 0),
                 helpText("Nota: Si Gamma = FALSE es un Holt"),
                 checkboxInput("gamm","Modelar estacionalidad Gamma", value = FALSE),
                 numericInput("gamma","Gamma", value = 0),
                 numericInput("prediccion","Número a predeccir", value = 0),
                 selectInput("hseasonal","Tipo de serie",
                             c("additive","multiplicative")),
                 actionButton("hw","Correr HW")
                 #textInput("nombre3","Nombre de la serie"),
                 #textInput("ejex3","Nombre del eje x"),
                 #textInput("ejey3","Nombre del eje y")
                 
               ),#sidebarPanel3
               mainPanel(
                 plotOutput("HW"),
                 h4("HW1"),
                 verbatimTextOutput("HW1"),
                 plotOutput("residualh")
               )#mainPanel3
             )#sidebarLayout3
    ),#tabPanel3
    
    tabPanel("ARIMA",
             sidebarLayout(
               sidebarPanel(
                 checkboxInput("im","Incluye media", value = TRUE),
                 numericInput("ar","Orden autoregresivo", value = 0),
                 numericInput("d","Orden diferencia", value = 0),
                 numericInput("ma","Orden media movil", value = 0),
                 numericInput("AR","Orden autoregresivo estacional", value = 0),
                 numericInput("D","Orden diferencia estacional", value = 0),
                 numericInput("MA","Orden media movil estacional", value = 0),
                 actionButton("arim","Correr arima"),
                 textInput("nombre4","Nombre de la serie"),
                 textInput("ejex4","Nombre del eje x"),
                 textInput("ejey4","Nombre del eje y")
                 
               ),#sidebarPanel3
               mainPanel(
                 plotOutput("arima"),
                 h4("arima1"),
                 verbatimTextOutput("arima1")
                 
               )#mainPanel3
             )#sidebarLayout3
    ),#tabPanel3
    
    tabPanel("Regresion tendencia",
             sidebarLayout(
               sidebarPanel(
                 textInput("nombre5","Nombre de la serie"),
                 textInput("ejex5","Nombre del eje x"),
                 textInput("ejey5","Nombre del eje y")
                 
               ),#sidebarPanel4
               mainPanel(
                  h4("lineal"),
                  verbatimTextOutput("lineal"),
                  h4("cuadratica"),
                  verbatimTextOutput("cuadratica"),
                  h4("cubica"),
                  verbatimTextOutput("cubica"),
                  h4("AICYBIC"),
                  verbatimTextOutput("AICYBIC"),
                  h4("shapiro"),
                  verbatimTextOutput("shapiro"),
                  plotOutput("regresion"),
                  plotOutput("residual")
                 
               )#mainPanel4
             )#sidebarLayout4
    ),#tabPanel4
    
    tabPanel("Regresion tendencia y estacionalidad",
             sidebarLayout(
               sidebarPanel(
                 textInput("mesrefe","Referencia estacional"),
                 textInput("nombre6","Nombre de la serie"),
                 textInput("ejex6","Nombre del eje x"),
                 textInput("ejey6","Nombre del eje y")
                 
               ),#sidebarPanel5
               mainPanel(
                 plotOutput("regresiont"),
                 h4("linealt"),
                 verbatimTextOutput("linealt"),
                 h4("cuadraticat"),
                 verbatimTextOutput("cuadraticat"),
                 h4("cubicat"),
                 verbatimTextOutput("cubicat"),
                 h4("AICYBICt"),
                 verbatimTextOutput("AICYBICt"),
                 h4("shapirot"),
                 verbatimTextOutput("shapirot"),

                 plotOutput("residualt")
                 
               )#mainPanel5
             )#sidebarLayout5
    )#tabPanel5
  )#navbarPage
))#shinyUI
