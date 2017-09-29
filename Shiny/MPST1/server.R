
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# Esta en la carpeta MPST1
library(shiny)
library(forecast)
library(shinyTree)
library(xlsx)
library(stats)
library(MASS)
library(car)
library(plotly)
library(ggplot2)
library(rJava)

#### Prueba 1 ####
shinyServer(function(input, output, session){
  ### Cargar datos ###
  serie <- eventReactive(input$cargar,{
    if(input$archivo == "Texto"){
      read.csv(file.choose(),header = input$header,sep = input$separador)
    }
    else if(input$archivo == "Excel"){
      read.xlsx(file.choose(), sheetIndex = input$hoja, header = input$header)
    }
    
  })
  ### Mostramos los datos
  output$datos <- renderTable({
    serie()
  })       
  ### Fin de cargar datos ###
  
  ### Crear serie ###
  seriecreada <- eventReactive(input$crearserie,{
    if(input$tiposerie == "Diaria"){
      dato <- serie()
      ts(dato,start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Mensual"){
      dato <- serie()
      ts(dato, start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie == "Trimestral"){
      dato <- serie()
      ts(dato, start = c(input$year,input$month), frequency = input$frecuencia)
    }
  })
  output$crear <- renderPrint(
    seriecreada()
  )
  output$tsdisplay <- renderPlot({
    tsdisplay(seriecreada(),main = input$nombre, xlab = input$ejex, ylab = input$ejey)
  })
  ### Fin de crear la serie ###
  
  ### Analisis Descriptivo ###
  output$summary <- renderPrint(
    summary(seriecreada())  
  )
  output$boxcox <- renderPrint({
    dato <- seriecreada()
    resul_lambda=powerTransform(dato)
    resul_lambda
    #summary(resul_lambda)
  })
  
  output$gboxcox <- renderPlot({
    dato <- seriecreada()
    boxcox(dato~1, lambda = seq(input$infe, input$supe, length = input$long), plotit = TRUE, 
           xlab = expression(lambda),
           ylab = "log-Likelihood")
  })
  
  output$transformar <- renderPlot({
    if(input$transformar =="No transformar"){
      dato <- seriecreada()
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      decompose(dato)
    }
    else if(input$transformar =="Logaritmo"){
      dato <- log10(seriecreada())
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      decompose(dato)
    }
    else if(input$transformar =="Raiz cuadrada"){
      dato <- sqrt(seriecreada())
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      decompose(dato)
    }
  })
  output$decompose <- renderPlot({
    if(input$transformar =="No transformar"){
      dato <- seriecreada()
      plot(decompose(dato, type = input$seasona))
    }
    else if(input$transformar =="Logaritmo"){
      dato <- log10(seriecreada())
      plot(decompose(dato,type = input$seasona))
    }
    else if(input$transformar =="Raiz cuadrada"){
      dato <- sqrt(seriecreada())
      plot(decompose(dato,type = input$seasona))
    }
  })
  ### Fin de Analisis Descriptivo ###
  
  ### Medias moviles ###
  output$ma <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
    ms <- ma(dato,order = input$order)
    lines(ms,col ="red")
    
  })
  
})
