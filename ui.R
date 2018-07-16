library(shiny)

ui <- fluidPage(
        
    titlePanel("USA Name Trends"),
    
    sidebarLayout(
        sidebarPanel(
            # Input birth year with number
            numericInput("yr", 
                         h5("Input birth year:"), 
                         value = 1981,
                         min = 1910,
                         max = 2017
            ), 
            
            # Input gender
            selectInput("gd", h4("Choose gender :")
                , choices = list("Female" = 1, "Male" = 2)
                , selected = 1
            )
            
        ),
        
        mainPanel(
              DT::dataTableOutput("table1")
              , DTOutput("table2")
              #, plotOutput("plot")
        )
    )
)


