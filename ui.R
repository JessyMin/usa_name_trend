library(shiny)
data <- read.csv("./Data/sample2.csv")


ui <- fluidPage(
        
    titlePanel("USA Name Trends"),
    
    sidebarLayout(
        
        sidebarPanel(
            
            # Select birth year
            selectInput(
                "year", h4("Select birth year :"),
                choices = unique(data$year),
                selected = 1990
            )
            
            
            # Input gender
            , radioButtons(
                "gender", h4("Select gender :"),
                choices = list('Female' = 'F', 'Male' = 'M'),
                selected = "F"
            )
            
            # Select Column
            , checkboxGroupInput(
                "show_vars", h4("Columns in dataset to show: "),
                choices = c('rank','name','count','rank_o','rank_up','status'),
                selected = c('rank','name','status')
            )
                        
        ),
        
        mainPanel(
            
                p(h4(textOutput("tableText"))),
                div(DT::dataTableOutput("table1"),
                      style = "width: 80%"),
                
                p(h4(textOutput("nameText"))),
                plotOutput("plot")
        )
    )
)


