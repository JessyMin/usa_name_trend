library(ggplot2)
library(DT)
library(dplyr)

# loading local data file
# setwd("/Users/jessymin/documents/usa_name_trend")
data <- read.csv("./data/sample2.csv", stringsAsFactors = F)


server <- function(input, output){

    #Filter data with year & gender
    selectedData <- reactive({ 
        req(input$year)
        req(input$gender)
        data <- data %>% 
            filter(year == input$year) %>%
            filter(gender == input$gender)    })

    ###########################################################    
    #Join 테이블
    joinedTable <- reactive({
        req(input$year)
        req(input$gender)
        y <- as.numeric(input$year)
        
        data1 <- sample %>% 
            filter(year == input$year) %>%
            filter(gender == input$gender)    
        
        data2 <- sample %>%
            filter(year == y - 3) %>%
            filter(gender == input$gender)    
        
        joinData <- data1 %>% 
            left_join(data2, by = c('name'='name'))
        rm(data1, data2)
        
        colnames(joinData) <- c('year','gender','rank','name','count','year_o','gender_o','rank_o','count_o')
        
        joinData <- joinData %>% 
            select(c(1:5), 8) 
        
        joinData <- joinData %>%
            mutate(rank_up = rank_o - rank)
        
        joinData <- joinData %>%
            mutate(status = case_when(
                joinData$rank_up > 0 ~ "▲",
                joinData$rank_up == 0 ~ "-",
                joinData$rank_up < 0 ~ "▽")
            )
        })
    
    

    #Reactive Gender Text
    genderText <- reactive({ 
        if (input$gender == "F") "Female" else "Male"
    })
    
    #테이블 설명 텍스트(성별/연도)
    output$tableText <- renderText({
        paste0(genderText(), " baby names in ", input$year)
    })
    
    #조인 테이블
    output$table1 <- renderDT({
        DT::datatable(
            joinedTable()[, input$show_vars, drop=FALSE],
            width=500,
            rownames=FALSE,
            selection='single'
        )
    })
    
    
    #Plot 설명 텍스트(선택한 이름)
    output$nameText <- renderText({
        req(input$table1_rows_selected)
        i <- input$table1_rows_selected
        name2 <- joinedTable()$name[[i]]
        paste0("Trend of the name you choosed : ", name2)
    })
    
    #선택한 이름 상세 테이블
    selectedName <- reactive({ 
        req(input$table1_rows_selected)
        i <- input$table1_rows_selected
        name2 <- joinedTable()$name[[i]]
        data <- subset(data, name %in% name2 & gender == input$gender)
    })
    
    #선택한 이름으로 Plot 그리기
    output$plot <- renderPlot({
        d <- selectedName()
        y <- as.numeric(input$year)
        ggplot(data=d, aes(year, count)) + geom_line(col='steelblue') + 
            theme_classic() +
            geom_vline(aes(xintercept = y), col='grey', alpha=0.6)
    })
    
 
    
  
}
