
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
      plot(decompose(dato, type = input$dseasonal))
    }
    else if(input$transformar =="Logaritmo"){
      dato <- log10(seriecreada())
      plot(decompose(dato,type = input$dseasonal))
    }
    else if(input$transformar =="Raiz cuadrada"){
      dato <- sqrt(seriecreada())
      plot(decompose(dato,type = input$dseasonal))
    }
  })
  ### Fin de Analisis Descriptivo ###
  
  ### Medias moviles ###
  output$ma <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre2, xlab = input$ejex2, ylab = input$ejey2, type = 'l')
    ms <- ma(dato,order = input$order)
    lines(ms,col ="red")
    legend("topleft",legend = c("serie","ma"), pch = c(2,3), col = c("black","red"))
  })
  
  ### Holt-Winter ###
  hw2 <- eventReactive(input$hw,{
    dato <- seriecreada()
    HoltWinters(dato,alpha = input$alpha, beta = input$beta, gamma = input$gamma, seasonal = input$hseasonal)
    
  })
  output$HW1 <- renderPrint({
    hw2()
  })
  
  output$HW <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre3, xlab = input$ejex3, ylab = input$ejey3, type = 'l')
    lines(fitted(hw2())[,1],col = "blue")
    legend("topleft",legend = c("serie","HW"), pch = c(2,3), col = c("black","blue"))
  })
  
  ### Arima ###

  ari <- eventReactive(input$arim,{
    dato <- seriecreada()
    Arima(dato,order = c(input$ar,input$d,input$ma), seasonal = c(input$AR,input$D,input$MA), include.mean = input$im)
    
  })
  output$arima1 <- renderPrint({
    ari()
  })
  
  output$arima <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre4, xlab = input$ejex4, ylab = input$ejey4, type = 'l')
    #ar <- Arima(dato,order = c(input$ar,input$d,input$ma), seasonal = c(input$AR,input$D,input$MA), include.mean = input$im)
    #lines(fitted(ar),col = "blue")
    lines(fitted(ari()),col = "blue")
    legend("topleft",legend = c("serie","ARIMA"), pch = c(2,3), col = c("black","blue"))
  })
  
  ### Regresion ###
  output$regresion <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre5, xlab = input$ejex5, ylab = input$ejey5, type = 'l')
    t <- 1:length(dato)
    lineal <- lm(dato ~ t + I(t^2))
    lines(fitted(lineal),col="blue")
    #cuadratica <- lm(dato ~ t + I(t^2))
    #lines(fitted(cuadratica),col="blue")
    #cubica <- lm(dato ~ t + I(t^2) + I(t^3))
    #lines(fitted(cubica),col="green")
    legend("topleft",legend = c("serie","l1"), pch = c(2,3), col = c("black","blue"))
  })
  
  output$lineal <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    lineal <- lm(dato ~ t + I(t^2))
    summary(lineal)
  })
  output$cuadratica <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    cuadratica <- lm(dato ~ t + I(t^2))
    summary(cuadratica)
  })
  
  output$cubica <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    cubica <- lm(dato ~ t + I(t^2) + I(t^3))
    summary(cubica)
  })
})
