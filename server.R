library(DT)
library(dplyr)
library(data.table)
library(readr)
library(ggplot2)


# loading local data file
# setwd("/Users/jessymin/Documents/Github/usa_name_trend")
data <- fread("usa_names_1963_current.csv", 
              colClasses = c("character", "character","integer", "character","character", 
                             "integer","integer","numeric","integer"))


server <- function(input, output){

    # 메인테이블 설명 텍스트("Femail baby name in 1960")
    genderText <- reactive({
      if (input$gender == "F") "여자" else "남자"
    })
    
    output$tableText <- renderText({
      paste0(input$year, "년에 출생한 ", genderText(), "아이 이름입니다. 마음에 드는 이름을 선택해보세요.")
    })
    
    
    # 메인테이블
    # input year & gender로 필터링
    filteredData <- reactive({
      
        req(input$year)
        req(input$gender)
        data <- data %>% filter(year == input$year & gender == input$gender) 
        
    })

    # 테이블 생성
    output$table1 <- renderDT({
      
        DT::datatable(
            filteredData()[, input$show_vars, drop=FALSE],
            width=500,
            rownames=FALSE,
            options=list(iDisplayLength=10,    # initial number of records
                         aLengthMenu=c(5,10), # records/page options
                         bLengthChange=0,     # show/hide records per page dropdown
                         bFilter=0,           # global search box on/off
                         bInfo=0,             # information on/off (how many records filtered, etc)
                         bAutoWidth=0        # automatic column width calculation, disable if passing column width via aoColumnDefs
                         #aoColumnDefs = list(list(sWidth="300px", aTargets=c(list(0),list(1))))    # custom column size                       
            ),
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
        paste0("영어이름 ", name_selected, "의 인기도 변화")

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
            geom_vline(aes(xintercept = y), col='grey', alpha=0.6) +
            theme_classic() +
            theme(text = element_text(size = 17)) 
      
    })

}

