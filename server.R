library(ggplot2)
library(DT)
library(dplyr)

# loading local data file
data <- read.csv("./Data/sample.csv", row.names=NULL)




server <- function(input, output){


    # filter data
    selectedData2 <- reactive({ 
        req(input$year)
        req(input$gender)
        data <- subset(data, 
            year == input$year & gender == input$gender)
        })
    
    selectedData <- reactive({ 
        req(input$year)
        req(input$gender)
        data <- data %>% 
            filter(year == input$year & gender == input$gender)# %>%
            #select(rank, count, name)
    })
    
    # Reactive name list
    all_names <- sort(unique(selectedData()$name))
    
    # Reactive Gender Text
    genderText <- reactive( if (input$gender == "F") "Female" else "Male")
    
    # Year Text
    output$tableInfoText <- renderText({
        paste0(genderText(), " baby names in ", input$year)
    })
    
    # 지정한 컬럼값만 나오게 하기
    output$table1 <- renderDT({
        DT::datatable(
            selectedData()[, input$show_vars, drop = FALSE], 
            width = 300,
            #colnames = c("Year" = year),
            rownames=FALSE
        )
    })
    
    # 이름 고르게 하기
    #updateSelectizeInput(session, 'name', choices = data, server = TRUE)
    
    
    #Test Plot
    #output$plot <- renderPlot({
    #    ggplot(data2(), aes(year, count, col=name)) + geom_line()
    #})
    
}
