library(DT)
library(dplyr)
library(data.table)
library(readr)
library(ggplot2)


# loading local data file
# setwd("/Users/jessymin/Documents/Github/usa_name_trend")
data <- fread("usa_names_1963_current.csv", 
              colClasses = c("character","character","integer","integer","numeric","integer","integer","integer","character"))


server <- function(input, output){

    # 메인테이블 설명 텍스트("Femail baby name in 1960")
    genderText <- reactive({
      if (input$gender == "F") "Female" else "Male"
    })
    
    output$tableText <- renderText({
      paste0(genderText(), " baby names in ", input$year)
    })
    
    
    # 메인테이블
    # input year & gender로 필터링
    filteredData <- reactive({
        req(input$year)
        req(input$gender)
        data <- data %>%
            filter(year == input$year & gender == input$gender)    
    })

    # 테이블 생성
    output$table1 <- renderDT({
        DT::datatable(
            filteredData()[, input$show_vars, drop=FALSE],
            width=500,
            rownames=FALSE,
            selection='single'
        )
    })

    
    ####################################################################
    
    # 선택한 이름으로 연도별 추이 Plot 그리기
    
    # Plot 설명 텍스트
    output$nameText <- renderText({
        req(input$table1_rows_selected)
        i <- input$table1_rows_selected
        name_selected <- filteredData()$name[[i]]
        paste0("Trend of the name you choosed : ", name_selected)
    })

    # 연도별 데이터 추출
    selectedName <- reactive({
        req(input$table1_rows_selected)
        i <- input$table1_rows_selected
        name_selected <- filteredData()$name[[i]]
        data <- data %>% filter(name %in% name_selected & gender == input$gender)
    })

    
    # 정규화된 값으로 Plot 그리기
    output$plot <- renderPlot({
        d <- selectedName()
        y <- as.numeric(input$year)
        ggplot(data=d, aes(year, norm)) + 
            geom_line(col='steelblue') +
            theme_classic() +
            geom_vline(aes(xintercept = y), col='grey', alpha=0.6)        
      })

}

