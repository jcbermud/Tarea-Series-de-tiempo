
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
library(TSA)


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
  serieoriginal <- eventReactive(input$crearserie,{
    if(input$tiposerie == "Diaria"){
      ts(serie(),start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Mensual"){
      ts(serie(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie == "Trimestral"){
      ts(serie(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
  })
  output$original <- renderPrint(
    serieoriginal()
  )
  output$tsdisplayoriginal <- renderPlot({
    tsdisplay(serieoriginal(),main = input$nombre, xlab = input$ejex, ylab = input$ejey)
  })
  seriecreada <- eventReactive(input$crearserie,{
     if(input$tiposerie == "Diaria"){
      t = 1:(length(serie()[,1])-input$lo)
      ts(serie()[t,1],start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Mensual"){
      t = 1:(length(serie()[,1])-input$lo)
      ts(serie()[t,1], start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie == "Trimestral"){
      t = 1:(length(serie()[,1])-input$lo)
      ts(serie()[t,1], start = c(input$year,input$month), frequency = input$frecuencia)
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
    boxcox(dato ~ 1, lambda = seq(input$infe, input$supe, length = input$long), plotit = TRUE, 
           xlab = expression(lambda),
           ylab = "log-Likelihood")
  })
  
  output$transformar <- renderPlot({
    if(input$transformar =="No transformar"){
      dato <- seriecreada()
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      
    }
    else if(input$transformar =="Logaritmo"){
      dato <- log10(seriecreada())
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      
    }
    else if(input$transformar =="Raiz cuadrada"){
      dato <- sqrt(seriecreada())
      plot(dato,main = input$nombre1, xlab = input$ejex1, ylab = input$ejey1,type = 'l')
      
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
  
  output$boxplot <- renderPlot({
    if(input$transformar =="No transformar"){
      dato <- seriecreada()
      boxplot(dato~cycle(dato))
    }
    else if(input$transformar =="Logaritmo"){
      dato <- log10(seriecreada())
      boxplot(dato~cycle(dato))
    }
    else if(input$transformar =="Raiz cuadrada"){
      dato <- sqrt(seriecreada())
      boxplot(dato~cycle(dato))
    }
  })
  
  ### Fin de Analisis Descriptivo ###
  
  ### Medias moviles ###
  output$ma <- renderPlot({
    dato <- seriecreada()
    plot(dato,main = input$nombre2, xlab = input$ejex2, ylab = input$ejey2, type = 'l')
    ms <- ma(dato,order = input$order)
    lines(ms,col ="red")
    legend("topleft",legend = c("serie","ma"), lty = 1 , col = c("black","red"))
  })
  
  ### Holt-Winter ###
  hw2 <- eventReactive(input$hw,{
   
    if(input$bet == FALSE & input$gamm == FALSE){
      dato <- seriecreada()
      HoltWinters(dato,alpha = input$alpha, beta = FALSE, gamma = FALSE, seasonal = input$hseasonal)
    }
    else if(input$bet != FALSE & input$gamm == FALSE){
      dato <- seriecreada()
      HoltWinters(dato,alpha = input$alpha, beta = input$beta, gamma = FALSE, seasonal = input$hseasonal)
    }
    else if(input$bet != FALSE & input$gamm != FALSE){
      dato <- seriecreada()
      HoltWinters(dato,alpha = input$alpha, beta = input$beta, gamma = input$gamma, seasonal = input$hseasonal)
    }
  })
  output$HW1 <- renderPrint({
    hw2()
    predict(hw2(),n.ahead=input$prediccion,prediction.interval = TRUE,level = 0.95)
  })
  output$HW <- renderPlot({
    dato <- seriecreada()
    p<-predict(hw2(),n.ahead=input$prediccion,prediction.interval = TRUE,level = 0.95)
    plot(dato,main = input$nombre3, xlab = input$ejex3, ylab = input$ejey3, type = 'l')
    plot(hw2(),p,lwd=2)
    legend("topleft",legend = c("serie","HW"),lty = 1, col = c("black","red"))
    
  })
  output$residualh <- renderPlot({
    dato <- seriecreada()
    t <- 1:length(dato)
    hw2()
    nf = layout(rbind(c(1,1,2,2,3,3)))
    plot(residuals(hw2()),type ='l', main = "Residuales vs tiempo\nHolt-Winter")
    abline(h=0,lty=2)
    
    plot(fitted(hw2())[,"xhat"],residuals(hw2()), main = "Residuales vs Ajustados\nHolt-Winter")
    abline(h=0,lty=2)
    
    qqnorm(residuals(hw2()))
    qqline(residuals(hw2()),col= 2 , lwd=2)
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
    legend("topleft",legend = c("serie","ARIMA"),lty=1, col = c("black","blue"))
  })
  
  ### Regresion ###
  output$regresion <- renderPlot({
    dato <- serieoriginal()
    dato1 <- seriecreada()
    plot(dato,main = input$nombre5, xlab = input$ejex5, ylab = input$ejey5,ylim = c(min(dato),max(dato)),lwd=3)
    
    t = 1:length(seriecreada())
    lineal <- lm(dato1 ~ t)
    par(new=T)
    plot(time(dato),predict(lineal,list(t=1:length(dato))), type = '1',col=2, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
    cuadratica <- lm(dato1 ~ t + I(t^2))
    par(new=T)
    plot(time(dato),predict(cuadratica,list(t=1:length(dato))), type = '1',col=3, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
    cubica <- lm(dato1 ~ t + I(t^2) + I(t^3))
    par(new=T)
    plot(time(dato),predict(cubica,list(t=1:length(dato))), type = '1',col=4, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
    legend("topleft",legend = c("serie","Lineal","Cudratica","Cubica"),lty=1, col = c(1,2,3,4),lwd = 2)
    abline(v = time(dato1)[length(t)],lty=2)
  })
  
  output$lineal <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    lineal <- lm(dato ~ t)
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
  output$AICYBIC <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    lineal <- lm(dato ~ t)
    cuadratica <- lm(dato ~ t + I(t^2))
    cubica <- lm(dato ~ t + I(t^2) + I(t^3))
    AICs <- c(AIC(lineal),AIC(cuadratica),AIC(cuadratica))
    BICs <- c(BIC(lineal),BIC(cuadratica),BIC(cuadratica))
    criterios <- rbind(AICs,BICs)
    colnames(criterios) <-c("Lineal","Cuadratico","Cubico")
    rownames(criterios) <-c("AIC","BIC")
    criterios
  })
  output$shapiro <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    lineal <- lm(dato ~ t)
    cuadratica <- lm(dato ~ t + I(t^2))
    cubica <- lm(dato ~ t + I(t^2) + I(t^3))
    test = rbind(shapiro.test(residuals(lineal)),shapiro.test(residuals(cuadratica)),shapiro.test(residuals(cubica)))
    rownames(test) <-c("Lineal","Cuadratico","Cubico")
    test
  })
  
  output$residual <- renderPlot({
    dato <- seriecreada()
    t <- 1:length(dato)
    lineal <- lm(dato ~ t)
    cuadratica <- lm(dato ~ t + I(t^2))
    cubica <- lm(dato ~ t + I(t^2) + I(t^3))
    nf = layout(rbind(c(1,1,2,2,3,3),c(4,4,5,5,6,6),c(7,7,8,8,9,9)))
    plot(t,residuals(lineal),type ='l', main = "Residuales vs tiempo\nModelo lineal")
    abline(h=0,lty=2)
    plot(t,residuals(cuadratica),type ='l', main = "Residuales vs tiempo\nModelo Cuadratico")
    abline(h=0,lty=2)
    plot(t,residuals(cubica),type ='l', main = "Residuales vs tiempo\nModelo Cubico")
    abline(h=0,lty=2)
    
    plot(fitted(lineal),residuals(lineal),type ='l', main = "Residuales vs Ajustados\nModelo lineal")
    abline(h=0,lty=2)
    plot(fitted(cuadratica),residuals(cuadratica),type ='l', main = "Residuales vs Ajustados\nModelo Cuadratico")
    abline(h=0,lty=2)
    plot(fitted(cubica),residuals(cubica),type ='l', main = "Residuales vs Ajustados\nModelo Cubico")
    abline(h=0,lty=2)
    
    qqnorm(residuals(lineal))
    qqline(residuals(lineal),col= 2 , lwd=2)
    qqnorm(residuals(cuadratica))
    qqline(residuals(cuadratica),col= 2 , lwd=2)
    qqnorm(residuals(cubica))
    qqline(residuals(cubica),col= 2 , lwd=2)
  })
  
  ### Regresion estacional ###
  
  output$regresiont <- renderPlot({
    dato <- serieoriginal()
    dato1 <- seriecreada()
    t = 1:length(seriecreada())
    #plot(dato,main = input$nombre6, xlab = input$ejex6, ylab = input$ejey6,ylim = c(min(dato),max(dato)),lwd=3,type='l')
    plot(t,dato1,main = input$nombre6, xlab = input$ejex6, ylab = input$ejey6,ylim = c(min(dato),max(dato)),lwd=3,type='l')
    mes = season(dato1)
    mes = relevel(mes,ref = input$mesrefe)
    lineal <- lm(dato1 ~ t+mes)
    lines(t,fitted(lineal),lwd=2,col=2)
    
    #par(new=T)
    #plot(time(dato),predict(lineal,list(t=1:length(dato))), type = '1',col=2, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
    cuadratica <- lm(dato1 ~ t + I(t^2)+mes)
    lines(t,fitted(cuadratica),lwd=2,col=3)
    #par(new=T)
    #plot(time(dato),predict(cuadratica,list(t=1:length(dato))), type = '1',col=3, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
    cubica <- lm(dato1 ~ t + I(t^2) + I(t^3)+mes)
    lines(t,fitted(cubica),lwd=2,col=4)
   # par(new=T)
   # plot(time(dato),predict(cubica,list(t=1:length(dato))), type = '1',col=4, xlab = " ", ylab = " ",ylim = c(min(dato),max(dato)),lwd=2)
    
   legend("topleft",legend = c("serie","Lineal","Cudratica","Cubica"),lty=1, col = c(1,2,3,4),lwd = 2)
    #abline(v = time(dato1)[length(t)],lty=2)
  })
  
  output$linealt <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    lineal <- lm(dato ~ t + mes)
    summary(lineal)
  })
  output$cuadraticat <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    cuadratica <- lm(dato ~ t + I(t^2)+mes)
    summary(cuadratica)
  })
  output$cubicat <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    cubica <- lm(dato ~ t + I(t^2) + I(t^3)+mes)
    summary(cubica)
  })
  output$AICYBICt <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    lineal <- lm(dato ~ t +mes)
    cuadratica <- lm(dato ~ t + I(t^2)+mes)
    cubica <- lm(dato ~ t + I(t^2) + I(t^3)+mes)
    AICs <- c(AIC(lineal),AIC(cuadratica),AIC(cuadratica))
    BICs <- c(BIC(lineal),BIC(cuadratica),BIC(cuadratica))
    criterios <- rbind(AICs,BICs)
    colnames(criterios) <-c("Lineal","Cuadratico","Cubico")
    rownames(criterios) <-c("AIC","BIC")
    criterios
  })
  output$shapirot <- renderPrint({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    lineal <- lm(dato ~ t+mes)
    cuadratica <- lm(dato ~ t + I(t^2)+mes)
    cubica <- lm(dato ~ t + I(t^2) + I(t^3)+mes)
    test = rbind(shapiro.test(residuals(lineal)),shapiro.test(residuals(cuadratica)),shapiro.test(residuals(cubica)))
    rownames(test) <-c("Lineal","Cuadratico","Cubico")
    test
  })
  
  output$residualt <- renderPlot({
    dato <- seriecreada()
    t <- 1:length(dato)
    mes = season(dato)
    mes = relevel(mes,ref = input$mesrefe)
    lineal <- lm(dato ~ t+mes)
    cuadratica <- lm(dato ~ t + I(t^2)+mes)
    cubica <- lm(dato ~ t + I(t^2) + I(t^3)+mes)
    nf = layout(rbind(c(1,1,2,2,3,3),c(4,4,5,5,6,6),c(7,7,8,8,9,9)))
    plot(t,residuals(lineal),type ='l', main = "Residuales vs tiempo\nModelo lineal")
    abline(h=0,lty=2)
    plot(t,residuals(cuadratica),type ='l', main = "Residuales vs tiempo\nModelo Cuadratico")
    abline(h=0,lty=2)
    plot(t,residuals(cubica),type ='l', main = "Residuales vs tiempo\nModelo Cubico")
    abline(h=0,lty=2)
    
    plot(fitted(lineal),residuals(lineal),type ='l', main = "Residuales vs Ajustados\nModelo lineal")
    abline(h=0,lty=2)
    plot(fitted(cuadratica),residuals(cuadratica),type ='l', main = "Residuales vs Ajustados\nModelo Cuadratico")
    abline(h=0,lty=2)
    plot(fitted(cubica),residuals(cubica),type ='l', main = "Residuales vs Ajustados\nModelo Cubico")
    abline(h=0,lty=2)
    
    qqnorm(residuals(lineal))
    qqline(residuals(lineal),col= 2 , lwd=2)
    qqnorm(residuals(cuadratica))
    qqline(residuals(cuadratica),col= 2 , lwd=2)
    qqnorm(residuals(cubica))
    qqline(residuals(cubica),col= 2 , lwd=2)
  })
  
  

})
