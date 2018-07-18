library(shiny)
data <- read.csv("./Data/sample.csv")


ui <- fluidPage(
        
    titlePanel("USA Name Trends"),
    
    sidebarLayout(
        sidebarPanel(
            # Input birth year with number
            numericInput("yr", 
                         h4("Input birth year:"), 
                         value = 1981,
                         min = 1910,
                         max = 2017
            ), 
            
            # Input gender
            selectInput("gd", h4("Choose gender :")
                , choices = list("Female" = 1, "Male" = 2)
                , selected = 1
            ),
            
            # Select Column
            checkboxGroupInput("show_vars", h4("Columns in dataset to show: "),
                               names(data), selected = names(data))
            
        ),
        
        mainPanel(
                DT::dataTableOutput("table1")
              , DT::dataTableOutput("table2")
              #, DTOutput("table2")
              #, plotOutput("plot")
        )
    )
)


