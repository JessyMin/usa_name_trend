library(shiny)
library(ggplot2)


ui <- fluidPage(

    titlePanel(h3("USA Name Trends")),

    sidebarLayout(

        sidebarPanel(

            # Select birth year
            selectInput(
                "year", h4("출생연도"),
                choices = c(1963:2007),
                selected = 1990
            )


            # Input gender
            , selectInput(
                "gender", 
                h4("성별"),
                choices = list('여자' = 'F', '남자' = 'M'),
                selected = "F"
            )

            # Select Column
            , checkboxGroupInput(
                "show_vars", 
                h5("표시할 정보"),
                choices = c('rank','status','rank_up','name','count'),
                selected = c('rank','name','status')
            )

        ),

        mainPanel(
                # 메인테이블 타이틀
                p(h4(textOutput("tableText"))),
                
                # 메인테이블
                div(DT::dataTableOutput("table1")),
                
                br(),
                  
                # 선택한 이름 안내문구 
                p(h3(textOutput("nameText"))),
                
                # 선택한 이름 연도별 추이 Plot
                plotOutput("plot")
                
        )
    )
)
