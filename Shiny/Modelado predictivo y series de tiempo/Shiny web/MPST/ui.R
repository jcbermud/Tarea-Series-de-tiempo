
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

### Códiggo original
#shinyUI(fluidPage(

  # Application title
#  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
 # sidebarLayout(
#    sidebarPanel(
#      sliderInput("bins",
#                  "Number of bins:",
#                  min = 1,
#                 max = 50,
#                  value = 30)
#    ),

    # Show a plot of the generated distribution
#    mainPanel(
#      plotOutput("distPlot")
#    )
# )
#))


### Prueba 1 ###
#shinyUI(fluidPage(
  
  # Application title
#  titlePanel("Mejorando"),
  
    # Show a plot of the generated distribution
 #   mainPanel(
#      plotOutput("distPlot")
#    )
  
#))


### Prueba 2 ###
#shinyUI(fluidPage(
  
  # Application title
#  titlePanel("Mejorando 1"),
  
  # Mostrando la tabla
#  mainPanel(
#    tableOutput("tabla")
#  )
  
#))


### Prueba 3 ###
#fluidPage(
#  titlePanel("Basic DataTable"),
  
  # Create a new Row in the UI for selectInputs
#  fluidRow(
#    column(4,
#           selectInput("man",
#                      "Manufacturer:",
#                       c("All",
#                         unique(as.character(mpg$manufacturer))))
#   ),
#    column(4,
#           selectInput("trans",
#                       "Transmission:",
#                       c("All",
#                         unique(as.character(mpg$trans))))
#    ),
#    column(4,
#           selectInput("cyl",
#                       "Cylinders:",
#                       c("All",
#                         unique(as.character(mpg$cyl))))
#    )
#  ),
  # Create a new row for the table.
 # fluidRow(
#    DT::dataTableOutput("table")
#  )
#)

### prueba 4 ###
#fluidPage(
#  titlePanel("Modelado predictivo y Series de tiempo"),
  
#  selectInput("base","Escoger variable:",
#              c("ESTATURA","MASA","EDAD","GASTOM","TIEMPO","INGRESO","GASERV","TODAS LAS VARIABLES")),
  
#  selectInput("base1","Escoger genero:",
#              c("HOMBRE","MUJER","AMBOS GENEROS")),
  
#  mainPanel(
#    h4("resumen"),
#    verbatimTextOutput("resumen"),
    #textOutput("resumen"),
#    tableOutput("tabla"),
#    plotOutput("histo")
#  )
  
#)


### Prueba 5 ###
#fluidPage(
  
#  titlePanel("Grafico de series de tiempo"),
  
#  sidebarLayout(
  
#    sidebarPanel(
      # Para ingresar el nombre de la serie de tiempo: NST
#      textInput("NST","Ingrese el nombre de la serie" ),
      # Para ingresar el nombre del eje x:NEX
#      textInput("NEX","Ingrese el nombre del eje x"),
      # Para ingresar el nombre del eje y:NEY
#      textInput("NEY","Ingrese el nombre del eje y")
     
     # actionButton("model","Correr modelo"),
      #  textInput("orden","Ingrese el orden estacionario" )
#    ),
  
  
#    mainPanel(
#      plotOutput("serie"),
#      plotOutput("acf1"),
#      plotOutput("pacf1"),
#      plotOutput("seas"),
#      h4("modelo"),
#      verbatimTextOutput("modelo")
    
#    )
#  )
#)


### Prueba 6
fluidPage(
  # Titulo de la obra
  titlePanel("Modelado predictivo y Series de tiempo"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("archivo","Tipo de archivo a leer",
                 c("txt","csv","xlsx","scan")),
      checkboxInput("header","Cabecera",value=TRUE),
      checkboxGroupInput("Separa","Separadores",
                         c("Espacio" = " ",
                           "Tabulacion"= "\t",
                           "Linea"="\n"),width = '50%'),
      numericInput("hoja","Hoja a elegir",value = 1),
      numericInput("frecuencia","frecuencia",value = 12),
      numericInput("ano","Year",value = 2017),
      numericInput("mes","Month",value = 01),
      numericInput("ar","ar",value=0,width = 80),
      numericInput("d","d",value=0,width = 80),
      numericInput("ma","ma",value=0,width = 80),
      numericInput("AR","AR",value=0,width = 80),
      numericInput("D","D",value=0,width = 80),
      numericInput("MA","MA",value=0,width = 80),
      checkboxInput("media","Include media",value = T),
      numericInput("alpha","alpha",value=0,width = 80),
      numericInput("beta","beta",value=0,width = 80),
      numericInput("gamma","gamma",value=0,width = 80),
      selectInput("seasonal","Selecione",
                  c("additive","multiplicative")),
      actionButton("carga","Cargar datos"),
      actionButton("serie","Crear serie"),
      actionButton("correr","Correr modelo")


            
    ),   
    mainPanel(
      plotOutput("plo"),
      plotOutput("acf"),
      plotOutput("pacf"),
      h4("model"),
      verbatimTextOutput("model"),
      h4("model1"),
      verbatimTextOutput("model1"),
      tableOutput("tabla"),
      plotOutput("plo1")
    )
  )
)
