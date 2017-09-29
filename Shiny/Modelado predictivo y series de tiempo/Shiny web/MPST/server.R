
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(forecast)
library(stats)
library(xlsx)
### codigo original
#shinyServer(function(input, output) {

#  output$distPlot <- renderPlot({

    # generate bins based on input$bins from ui.R
#    x    <- faithful[, 2]
#    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
#    hist(x, breaks = bins, col = 'darkgray', border = 'white')

 # })

#})

### Prueba 1 ###
#shinyServer(function(input, output) {
  
#  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
#    x    <- faithful[, 2]
    
#    boxplot(x, col = 'red')
    
#  })
  
#})

### Prueba 2 ###
#datos <- read.table(file.choose(),header = T)
#datos

#shinyServer(function(input,output){
  
#  output$tabla <- renderTable({
    
#    datos
    
#  })
  
#})



### Prueba 3 ###
#function(input, output) {
  
  # Filter data based on selections
 # output$table <- DT::renderDataTable(DT::datatable({
#    data <- mpg
#    if (input$man != "All") {
#      data <- data[data$manufacturer == input$man,]
#    }
#    if (input$cyl != "All") {
#      data <- data[data$cyl == input$cyl,]
#    }
#    if (input$trans != "All") {
#      data <- data[data$trans == input$trans,]
#    }
#    data
#  }))
  
#}

 #### prueba 4 ##

#datos <- read.table('C:/EstebanRuiz/Materias de Posgrado/Modelado predictivo y series de tiempo/Shiny web/MPST/base_trab1.txt',header = T)
#shinyServer(function(input, output){
  
#  output$resumen <- renderPrint(
#    if (input$base =="TODAS LAS VARIABLES" & input$base1 =="AMBOS GENEROS"){
#          summary(datos,cex = 0.8)
#    }
#  )
  
#  output$tabla <- renderTable(

#    if(input$base == "TODAS LAS VARIABLES" & input$base1=="AMBOS GENEROS"){
#      {return(datos)}
#    }    
#    else if(input$base == "ESTATURA" & input$base1=="HOMBRE"){
#      {return(datos[datos$GENERO=="HOMBRE",]$ESTATURA)}
#    }
#    else if(input$base == "ESTATURA" & input$base1=="MUJER"){
#      {return(datos[datos$GENERO=="MUJER",]$ESTATURA)}
#    } 
#    else if(input$base == "ESTATURA" & input$base1=="AMBOS GENEROS")
#    {
#      {return(datos$ESTATURA)}
#    }
#    else if(input$base == "MASA" & input$base1=="HOMBRE"){
#      {return(datos[datos$GENERO=="HOMBRE",]$MASA)}
#    }
#    else if(input$base == "MASA" & input$base1=="MUJER"){
#      {return(datos[datos$GENERO=="MUJER",]$MASA)}
#    } 
#    else if(input$base == "MASA" & input$base1=="AMBOS GENEROS")
#    {
#      {return(datos$MASA)}
#    }
    
#    )
  
#  output$histo <- renderPlot(
    
#    if(input$base == "TODAS LAS VARIABLES" & input$base1=="AMBOS GENEROS"){
#      pairs(datos)
#    }
#    else if(input$base == "ESTATURA" & input$base1=="HOMBRE"){
#      hist(datos[datos$GENERO=="HOMBRE",]$ESTATURA,col="red",main = "ESTATURAS DE HOMBRES",xlab = "ESTATURAS")
#    }
#    else if(input$base == "ESTATURA" & input$base1=="MUJER"){
#      hist(datos[datos$GENERO=="MUJER",]$ESTATURA,col="red",main ="ESTATURAS DE MUJERES", xlab = "ESTATURAS")
#    } 
#    else if(input$base == "ESTATURA" & input$base1=="AMBOS GENEROS"  )
#    {
#      hist((datos$ESTATURA),col="red", main = "ESTATURAS",xlab = "ESTATURAS")
#    }
#    else if(input$base == "MASA" & input$base1=="HOMBRE"){
#      hist(datos[datos$GENERO=="HOMBRE",]$MASA,col="red")
#    }
#    else if(input$base == "MASA" & input$base1=="MUJER"){
#      hist(datos[datos$GENERO=="MUJER",]$MASA,col="red")
#    } 
#    else if(input$base == "MASA" & input$base1=="AMBOS GENEROS")
 #   {
#      hist((datos$ESTATURA),col="red")
#    }
    
    
#  )    
  
#})

### FIN PRUEBA 4 ##


### PRUEBA 5 ##
#shinyServer(function(input, output){
  #Datos de la produccion de gas en Australia
#  data(gas)
# gas
  
#  output$serie <- renderPlot(
    #Grafico de la serie de tiempo
#    plot.ts(gas,main = input$NST, xlab=input$NEX, ylab=input$NEY)
   
    #seasonplot(gas)
    #tsdisplay(gas)
    
#  )
  
#  output$acf1 <- renderPlot(
    # Grafico de acf de la serie de tiempo
#    acf(gas)
  
#  )
#  output$pacf1 <- renderPlot(
    # Grafico de la pacf de la serie de tiempo
#    pacf(gas)
    
#  )
#  output$seas <- renderPlot(
#    seasonplot(gas)
#  )
#  output$modelo <- renderPrint(
  
#    Arima(gas,order = c(1,0,1) ,seasonal = c(1,0,0), include.mean = T)
#  )
  
#})


### Prueba 6 ###
shinyServer(function(input, output){

 datos <- eventReactive(input$carga, {
  if(input$archivo == "txt"){
  read.table(file.choose(),header = input$header,sep=input$Separa)
  }  
  else if(input$archivo == "csv")  {
  read.csv(file.choose(),header = input$header,sep=input$separa)
    }
  else if(input$archivo == "xlsx"){
   read.xlsx(file.choose(),sheetIndex = input$hoja, header = input$header)
  }
   #scan("C:/EstebanRuiz/ESCUELA UNALMED/Series de Tiempo/Datos libro Wei txt para R/W6.txt")   
   else if(input$archivo == "scan"){
    scan(file.choose())    
   }   
  })  
 
  #output$tabla <- renderTable(
  #  datos()
  #)
  serie <- eventReactive(input$serie,{
   ts(datos(),start = c(input$ano,input$mes),frequency = input$frecuencia)
  })
 
  output$plo <- renderPlot({
   datos()
   data <- serie()
   plot(data,main = "Serie",type="l")
   })
  output$acf <- renderPlot({
    datos()
    data <- serie()
    acf(data)
  })
  output$pacf <- renderPlot({
    datos()
    data <- serie()
    pacf(data)
  })
  
  
  arima1 <- eventReactive(input$correr,{
    data <-serie()
    Arima(data,order = c(input$ar,input$d,input$ma) ,seasonal = c(input$MA,input$D,input$MA), include.mean = input$media)
  })
  
  output$model <- renderPrint({
    arima1()
  })
  
  holt_winter <- eventReactive(input$correr,{
    data <- serie()
    HoltWinters(data,alpha = input$alpha,beta =input$beta ,gamma =input$gamma, seasonal = c(input$seasonal))
    
  })
  output$model1 <- renderPrint({
    holt_winter()
  })
  output$plo1 <- renderPlot({
    data <-serie()
    #Ajuste del modelo arima
    modeloarima <-arima1()
    resa<-residuals(modeloarima)
    ajusta <- (data-resa)
    ts.plot(data,ajusta)   
    lines(data, col="black")
    lines(ajusta, col="red")
    
    #Ajuste del modelo Holt-Winter
    holtWinter <- holt_winter()
    resh <-residuals(holtWinter)
    ajusth <- (data-resh)
    lines(ajusth,col="blue")
    legend("topright",legend = c("arima","HoltWinter"),col=c("red","blue"),pch = c(2,3))
    
  })
  
  
})