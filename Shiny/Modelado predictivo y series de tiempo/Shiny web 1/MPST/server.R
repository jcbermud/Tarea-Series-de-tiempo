
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(markdown)
library(forecast)
library(shinyTree)
library(shinyDND)
library(car)
library(MASS)


### Prueba 1

shinyServer(function(input, output, session){
  #### Para cargar los datos  
  archi <- eventReactive(input$boton,{
    if(input$archivo == "txt"){
      read.table(file.choose(),header=input$header,sep = input$separador)
    }
  })  
  archi1 <- eventReactive(input$boton1,{
    if(input$archivo1 == "xlsx"){
       read.xlsx(file.choose(),sheetIndex = input$hoja,header = input$header)
      }
  })
  
  archi2 <- eventReactive(input$boton2,{
    if(input$archivo2 == "csv"){
      read.csv(file.choose(),header=input$header, sep = input$separador)
    }
  })
  
  archi3 <- eventReactive(input$boton3,{
    if(input$archivo3 == "scan"){
      scan(file.choose(),sep = input$separador)
    }
  })
  
  #### Mostramos los datos
  ## Datos de txt 
  output$datos <- renderTable({
    datos <- archi()
  })
  ## Datos de excel
  output$datos1 <- renderTable({
    datos <- archi1()
   })
  ## Datos de csv
  output$datos2 <- renderTable({
    datos <- archi2()
  })
  ## Datos de scan
  output$datos3 <- renderTable({
    datos <- archi3()
  })
  
  #### Crear la serie #####
  #### Crea serie diaria
  serie <- eventReactive(input$serie,{
    if(input$tiposerie == "Diaria" & input$procedencia == "txt"){
       ts(archi(),start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Diaria" & input$procedencia == "xlsx"){
      ts(archi1(),start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Diaria" & input$procedencia == "csv"){
      ts(archi2(),start = 1,frequency = 1)
    }
    else if(input$tiposerie == "Diaria" & input$procedencia == "scan"){
      ts(archi3(),start = 1,frequency = 1)
    }
   })
  ## Plot de serie diaria
  output$serie <- renderPrint({
    serie()
  })
  output$plot <- renderPlot({
      dato <-serie()
      plot(dato,main = input$nombre,xlab =input$ejex,ylab=input$ejey, type="l")
  })
  output$acf <-renderPlot({
    dato <- serie()
    acf(dato)
  })
  output$pacf <-renderPlot({
    dato <- serie()
    pacf(dato)
  })
  #### crea serie mensual
  serie1 <- eventReactive(input$serie1,{
    if(input$tiposerie1 == "Mensual" & input$procedencia1 == "txt"){
      ts(archi(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie1 == "Mensual" & input$procedencia1 == "xlsx"){
      ts(archi1(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie1 == "Mensual" & input$procedencia1 == "csv"){
      ts(archi2(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie1 == "Mensual" & input$procedencia1 == "scan"){
      ts(archi3(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
  })
  ## Plot de serie mensual
  output$serie1 <- renderPrint({
    serie1()
  })
  output$plot1 <- renderPlot({
    dato <-serie1()
    plot(dato,main = input$nombre,xlab =input$ejex,ylab=input$ejey, type="l")
  })
  output$acf1 <-renderPlot({
    dato <- serie1()
    acf(dato)
  })
  output$pacf1 <-renderPlot({
    dato <- serie1()
    pacf(dato)
  })
  
  #### Crea serie trimestral
  serie2 <- eventReactive(input$serie2,{
    if(input$tiposerie2 == "Trimestral" & input$procedencia2 == "txt"){
      ts(archi(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie2 == "Trimestral" & input$procedencia2 == "xlsx"){
      ts(archi1(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie2 == "Trimestral" & input$procedencia2 == "csv"){
      ts(archi2(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
    else if(input$tiposerie2 == "Trimestral" & input$procedencia2 == "scan"){
      ts(archi3(), start = c(input$year,input$month), frequency = input$frecuencia)
    }
  })
  
  ## Plot de serie trimestral
  output$serie2 <- renderPrint({
    serie2()
  })
  output$plot2 <- renderPlot({
    dato <-serie2()
    plot(dato,main = input$nombre,xlab =input$ejex,ylab=input$ejey, type="l")
  })
  output$acf2 <-renderPlot({
    dato <- serie2()
    acf(dato)
  })
  output$pacf2 <-renderPlot({
    dato <- serie2()
    pacf(dato)
  })
#### Analisis descriptivo serie
  ## Para la serie diaria
 
  output$summary <- renderPrint({
    if(input$tiposerie3 == "Diaria"){  
        dato <- serie()
        summary(dato)
    }
    else if(input$tiposerie3 == "Mensual"){
      dato <- serie1()
      summary(dato)
    }
    else if(input$tiposerie3 == "Trimestral"){
      dato <- serie2()
      summary(dato)
    }
  })
  
  output$boxcox <- renderPrint({
    if(input$tiposerie3 == "Diaria"){  
      dato <- serie()
      resul_lambda=powerTransform(dato)
      summary(resul_lambda)
    }
    else if(input$tiposerie3 == "Mensual"){
      dato <- serie1()
      resul_lambda=powerTransform(dato)
      summary(resul_lambda)
    }
    else if(input$tiposerie3 == "Trimestral"){
      dato <- serie2()
      resul_lambda=powerTransform(dato)
      summary(resul_lambda)
    }
  })
  
  output$seasonal <- renderPlot({
    if(input$tiposerie3 == "Diaria"){  
      dato <- serie()
      seasonplot(dato)
    }
    else if(input$tiposerie3 == "Mensual"){
      dato <- serie1()
      seasonplot(dato)
    }
    else if(input$tiposerie3 == "Trimestral"){
      dato <- serie2()
      seasonplot(dato)
    }
  })
  
  output$tsdisplay <- renderPlot({
    if(input$tiposerie3 == "Diaria"){  
      dato <- serie()
      tsdisplay(dato)
    }
    else if(input$tiposerie3 == "Mensual"){
      dato <- serie1()
      tsdisplay(dato)
    }
    else if(input$tiposerie3 == "Trimestral"){
      dato <- serie2()
      tsdisplay(dato)
    }
  })
  
  output$tsdisplay <- renderPlot({
    if(input$tiposerie3 == "Diaria" & input$transformar == "No transformar"){  
      dato <- serie()
      tsdisplay(dato)
    }
    else if(input$tiposerie3 == "Mensual"){
      dato <- serie1()
      tsdisplay(dato)
    }
    else if(input$tiposerie3 == "Trimestral"){
      dato <- serie2()
      tsdisplay(dato)
    }
  })
  
  
})

