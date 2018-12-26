library(shiny)
library(ggplot2)


ui <- fluidPage(

    titlePanel("USA Name Trends"),

    sidebarLayout(

        sidebarPanel(

            # Select birth year
            selectInput(
                "year", h4("Select birth year :"),
                choices = c(1963:2007),
                selected = 1990
            )


            # Input gender
            , radioButtons(
                "gender", 
                h4("Select gender :"),
                choices = list('Female' = 'F', 'Male' = 'M'),
                selected = "F"
            )

            # Select Column
            , checkboxGroupInput(
                "show_vars", 
                h4("Columns in dataset to show: "),
                choices = c('name','count','rank','status','rank_up','rank_previous'),
                selected = c('rank','name','status')
            )

        ),

        mainPanel(
                # 메인테이블 타이틀
                p(h4(textOutput("tableText"))),
                
                # 메인테이블
                div(DT::dataTableOutput("table1"),
                      style = "width: 80%"),
                
                # 선택한 이름 안내문구 
                p(h4(textOutput("nameText"))),
                
                # 선택한 이름 연도별 추이 Plot
                plotOutput("plot")
                
        )
    )
)
