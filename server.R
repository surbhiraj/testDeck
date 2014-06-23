library(shiny)
library(ggplot2)
library(rCharts)
library(rHighcharts)
library(rgl)
library(shinyRGL)
library(devtools)
options (RCHART_LIB = 'Highcharts')

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Filter data based on selections
  dist <- reactive({
    input$goButton
    data <- diamonds
    colnames(data) <- c("Carat", "Cut", "Color", "Clarity", "Depth %", 
                        "Table", "Price", "Length", "Width", "Depth")
    if (input$cu != "All"){
      data <- data[data$Cut == input$cu,]
    }
    if (input$col != "All"){
      data <- data[data$Color == input$col,]
    }
    if (input$cla != "All"){
      data <- data[data$Clarity == input$cla,]
    }
    data<-data[data$Carat>=input$ca[1],]
    data<-data[data$Carat<=input$ca[2],]
    data<-data[data$Price>=input$pr,]
    data<-data[data$Price<=input$pri,]
    
  })
  
  
  selectedData <- reactive({
    dataset<-dist()
    dataset<-subset(dataset, select=c(input$xcol, input$ycol))
  })
  #Table output based on selected data
  output$table <- renderDataTable({
    input$goButton
    dist()
  })
  #Summary output for the selected data
  output$summary <- renderPrint({
    summary(dist())
  })
  #Plot output for the selected data based on user-defined x- and y-variables.
  output$plot <- renderPlot({
    input$goButton
    sdata<-selectedData()
    c<-subset(sdata, select=input$plotcolor)
    plot(sdata,
         col =as.integer(unique(c[[1]])))
  })
  
  #Download option to save data in .csv format
  output$downloadData <- downloadHandler(
    filename = function() { paste("your_diamonds.csv") },
    content = function(file) {
      write.csv(dist(), file)
    })
  
  #Pie chart for Cut
  output$chartcu <-renderChart2({
    a <- Highcharts$new()
    dataset<-dist()
    b<-levels(dataset$Cut)
    a$title(text = "Diamond Cut")
    a$data(x = c(b[1], b[2], b[3], b[4], b[5]), 
           y = c(sum(dataset[,2]==b[1]), sum(dataset[,2]==b[2]), 
                 sum(dataset[,2]==b[3]), sum(dataset[,2]==b[4]), 
                 sum(dataset[,2]==b[5])), type = "pie", name = "Count")
    a$legend(symbolWidth = 80)

    a
  })
  
  #Pie chart for Color
  output$chartco <-renderChart2({
    c <- Highcharts$new()
    dataset<-dist()
    d<-levels(dataset$Color)
    c$title(text = "Diamond Color")
    c$data(x = c(d[1], d[2], d[3], d[4], d[5], d[6], d[7]), 
           y = c(sum(dataset[,3]==d[1]), sum(dataset[,3]==d[2]), 
                 sum(dataset[,3]==d[3]), sum(dataset[,3]==d[4]), 
                 sum(dataset[,3]==d[5]), sum(dataset[,3]==d[6]), 
                 sum(dataset[,3]==d[7])), type = "pie", name = "Count")
    c$legend(symbolWidth = 80)

    c
  })
  
  #Pie chart for Clarity
  output$chartcl <-renderChart2({
    e <- Highcharts$new()
    dataset<-dist()
    d<-levels(dataset$Clarity)
    e$title(text = "Diamond Clarity")
    e$data(x = c(d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8]), 
           y = c(sum(dataset[,4]==d[1]), sum(dataset[,4]==d[2]), sum(dataset[,4]==d[3]), 
                 sum(dataset[,4]==d[4]), sum(dataset[,4]==d[5]), sum(dataset[,4]==d[6]), 
                 sum(dataset[,4]==d[7]), sum(dataset[,4]==d[8])), 
           type = "pie", name = "Count")
    e$legend(symbolWidth = 80)

    e
  })
  


})
