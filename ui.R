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
            
            #테스트용 텍스트인풋
            , textInput(
                "name", h3("Type name :"), 
                value = ""   
            )
            
            
            # 이름 고르기
            #, selectizeInput(
            #    'name', h4("Name to show detail: "),
            #    choices = unique(data$name),
            #    options = list(placeholder = 'type a name')
            #)

            #이름 고르기
            #, selectInput(
            #    'name', h4("Name to show detail: "),
            #    choices = unique(data$name),
                #placeholder = 'type a name',
            #    selectize = TRUE,
            #    multiple = FALSE
            #)
             #           selected = "20th Century Fox",
             #           selectize = TRUE,
             #           multiple = TRUE)
        
                        
        ),
        
        mainPanel(
            
                p(h4(textOutput("tableInfoText")))

                , div(DT::dataTableOutput("table3")
                      , style = "width: 80%")
                
                , plotOutput("plot1")
        )
    )
)


