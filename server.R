library(ggplot2)
library(DT)
library(dplyr)

# loading local data file
data <- read.csv("./Data/sample.csv")



server <- function(input, output){


    # filter data
    selectedData <- reactive({    
        data <- subset(data, year == input$yr)
        })
    

    
    #Test table
    output$table1 <- DT::renderDataTable({ data })
    
    output$table2 <- DT::renderDataTable({ selectedData() })

    #한번에 5줄씩만 나오게 하기
    #output$table2 <- DT::renderDataTable({
    #    DT::datatable(data, options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
    #})
    
    # 지정한 컬럼값만 나오게 하기
    output$table3 <- renderDT({ 
        DT::datatable(data[, input$show_vars, drop = FALSE])
        })
    
    #Test Plot
    #output$plot <- renderPlot({
    #    ggplot(data2(), aes(year, count, col=name)) + geom_line()
    #})
    

    #output$table <- DT::renderDataTable({
     #   df_year <- data %>%
      #          filter(gender == gd) %>%
       #         filter(year == yr) %>%
        #        group_by(name) %>%
         #       summarise(count = sum(number)) #%>%
                #mutate(ranks = rank(-count)) %>%
                #arrange(ranks)
       # DT::datatable(data = df_year, 
        #                  options = list(pageLength = 10), 
         #                 rownames = FALSE)
    
}
