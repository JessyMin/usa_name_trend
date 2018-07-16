library(ggplot2)
library(DT)
library(dplyr)

# loading local data file
data <- read.csv("./Data/sample.csv")



server <- function(input, output){

    # define reactive function    
    #data2 =reactive({
    #       data2 <- subset(data, data$year == input$yr)
    #       return(data2)
            
    #}) 
    
    #Test table
    output$table1 <- DT::renderDataTable({ data })

    output$table2 <- renderDT({ data })
    
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
