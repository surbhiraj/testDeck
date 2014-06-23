library(shiny)
library(rCharts)

# Load the ggplot2 package which provides
# the 'diamonds' dataset.
library(ggplot2)
#Define RCHART options so that pie charts can render properly as Highcharts
options (RCHART_LIB = 'Highcharts')

# Define the overall UI
shinyUI(
  fluidPage(
    titlePanel(
      tags$link(rel="shortcut icon", href="http://unbreakable-diamond.blogspot.com/favicon.ico"), 
"Diamond Search Portal v1.0"),
tags$span(tags$h2(tags$img(src = "https://cdn3.iconfinder.com/data/icons/linecons-free-vector-icons-pack/32/diamond-512.png", 
width="50px", height="auto"), "Diamond Search Portal"))
    ,
    
    # Define the sidebar with seletInputs
    sidebarLayout(
      sidebarPanel(
        tags$h4('Filter Panel', align="center"),
        
        numericInput("pr", "Price Range (in US$):", 0,
                     min = 0, max = 19000),
        numericInput("pri", "to", 19000, min=0, max=19000),
        selectInput("cu", "Cut:", c("All",levels(diamonds$cut))),
        
        selectInput("col", 
                    "Color:", 
                    c("All", 
                      levels(diamonds$color))),
        selectInput("cla", 
                    "Clarity:", 
                    c("All", 
                      levels(diamonds$clarity))),
        sliderInput("ca", "Carat:", 0, 5.6, c(0, 5.6), 0.01),
        tags$div(submitButton("Update View"), align="center"),
        tags$div(tags$br()
        ),
        tags$div("Click on the button below to download data in .csv format.",tags$br(), tags$br()),
        tags$div(downloadButton('downloadData', 'Download'), align="center"),
        tags$div(tags$br()
        ),
        withTags(
div(h4('Description'),
                p('A dataset containing the prices and other attributes of almost 54,000 round cut diamonds. 
The variables are as follows:',
                  br(),
                  br(b('Cut:'), 'quality of the cut (Fair, Good, Very Good, Premium, Ideal)'),
                 br(b("Carat:"), 'weight of the diamond (0.2--5.01)'),
                 br(b('Color:'), 'diamond colour, from J (worst) to D (best)'),
                 br(b('Clarity:'), 'a measurement of how clear the diamond is (I1 (worst), SI1, SI2, VS1, VS2, VVS1, VVS2, IF (best))'),
                 br(b('Depth %:'), 'total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43--79)'),
                 br(b('Table:'), 'width of top of diamond relative to widest point (43--95)'),
                 br(b('Price:'), 'price in US dollars ($326--$18,823)'),
                 br(b('Length:'), 'length in mm (0--10.74)'),
                 br(b('Width:'), 'width in mm (0--58.9)'),
                 br(b('Depth:'), 'depth in mm (0--31.8)')
                 
                 )))
      ),        
      
      
      # Define the main panel which is divided into tabs.
      mainPanel(tags$br(),
        tabsetPanel(type = "tabs", 
                    tabPanel("Table", dataTableOutput(outputId="table") ), 
                    tabPanel("Summary", verbatimTextOutput("summary") ),
                    tabPanel("Plot", 
                             column(3,
                                    selectInput('xcol', 'X-Variable', 
                                         c("Carat", "Cut", "Color", "Clarity", "Depth %", 
                                        "Table", "Price", "Length", "Width", "Depth"),
                             selected="Carat")),
                             column(3,
                                    selectInput('ycol', 'Y-Variable', c("Carat", "Cut", "Color", "Clarity", "Depth %", 
                                                                 "Table", "Price", "Length", "Width", "Depth"),
                                         selected="Price")),
                             column(3,
                                    selectInput('plotcolor', 'Plot Color',c("Carat", "Cut", "Color", "Clarity", "Depth %", 
                                                                            "Table", "Price", "Length", "Width", "Depth"), ,
                                                selected="Carat")),
                            column(3),
                            column(3,
                                    submitButton("Update Plot")),
                            column(12, 
                                   tags$em('Please select "Plot Color" as either the X-variable or Y-variable.')),
                             plotOutput("plot", height=500)),
                    tabPanel("Pie Chart", "The three pie charts show you data regarding Cut, 
                             Color and Clarity of Diamonds per your selections.", 
                             div(class = "row",
                                 div(showOutput("chartcu", "Highcharts"), class = "span3"),
                                 div(class="span3"),
                                 div(showOutput("chartco", "Highcharts"), class = "span3")
                             ),
                             div(class = "row",
                                 div(class="span3"),
                                 div(showOutput("chartcl", "Highcharts"), class = "span3", style = "center"),
                                 div(class="span3")
                             )

                             )
                   

                    
        ) #tabsetPanel
        
      )  #mainPannel
    ) #sidebarLayout  
  )) #shinyUI and fluidPage

