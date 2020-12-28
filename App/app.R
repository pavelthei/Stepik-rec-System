library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(markdown)
library(knitr)
# library(kableExtra)
#hi
source("futr2.R")

ui <- navbarPage(theme = "https://bootswatch.com/3/cyborg/bootstrap.min.css",
                 #position = "fixed-top",
                 "Stepik RecSys",
                 tabPanel("Home",
                          tags$div(class="header", checked=NA,
                                   tags$p("Привет!", align = "left", style="color:white; font-size: 40px"), align = "left", style = "background: black; width: 18%"),
                          tags$div(class="header", checked=NA,
                                   tags$p("Представляем Вам нашу рекомендательную систему, которая подберет для Вас курсы на Stepik,
исходя из Ваших предпочтений.", align = "left", style="color:white; font-size: 25px"), align = "left", style = "background: black; width: 100%"),
                          br(),
                          tags$div(class="header", checked=NA,
                                   tags$p("Если Вы еще не проходили курсы на Stepik, то выбирайте вкладку «New user»: проходите небольшой опрос и готовьтесь получать новые знания!", 
                                          align = "left", style="color:white; font-size: 22px"), align = "left", style = "background: black; width: 90%"),
                          br(),
                          tags$div(class="header", checked=NA,
                                   tags$p("Если же Вы уже были студентом некоторых курсов данной платформы, то переходите на вкладку «Login», вводите свои любимые курсы, а все остальное мы сделаем за Вас.", 
                                          align = "left", style="color:white; font-size: 22px"), align = "left", style = "background: black; width: 90%"),
                          br(),
                          tags$div(class="header", checked=NA,
                                   tags$p("Также можете воспользоваться нашим Телеграм-ботом: @courses_rec_bot", align = "left", style="color:white; font-size: 30px"), align = "left", style = "background: black; width: 45%"),
                          br(),
                          tags$div(class="header", checked=NA,
                                   tags$p("Рекомендательную систему сделали:", align = "left", style="color:white; font-size: 20px"), align = "left", style = "background: black; width: 45%"),
                          
                          tags$div(class="header", checked=NA,
                                   tags$p("Елизаров Павел, ОП Экономика;", align = "left", style="color:white; font-size: 18px"), align = "left", style = "background: black; width: 35%"),
                          
                          tags$div(class="header", checked=NA,
                                   tags$p("Леонова Александра, ОП Экономика;", align = "left", style="color:white; font-size: 18px"), align = "left", style = "background: black; width: 40%"),
                          
                          tags$div(class="header", checked=NA,
                                   tags$p("Сергеева Арина, ОП Социология;", align = "left", style="color:white; font-size: 18px"), align = "left", style = "background: black; width: 35%"),
                          
                          tags$div(class="header", checked=NA,
                                   tags$p("Быков Юрий, ОП Менеджмент", align = "left", style="color:white; font-size: 18px"), align = "left", style = "background: black; width: 35%"),
                          
                          
                 ),
                 tags$head(
                   tags$style(HTML("body{ 
                background-image: url( https://sun9-67.userapi.com/c206816/v206816696/12679a/Rp7nS58YEa4.jpg );}"))),
                 
                 
                 tabPanel("New user",
                          sidebarLayout(
                            sidebarPanel('Готовы ли Вы платить за прохождение курса?',
                                         radioButtons("pay", label = NULL,
                                                      choices = list("Да" = TRUE, "Нет" = FALSE), 
                                                      selected = 1),
                                         'Сколько времени Вы готовы потратить на прохождение курса? (от/до)',
                                         chooseSliderSkin("Flat"),
                                         setSliderColor(c("#31982B","#31982B", "#31982B"), c(1, 2, 3)),
                                         selectInput("time", NULL, 
                                                     times$time ,
                                                     multiple = FALSE),
                                         'По какой теме Вы хотели бы пройти курс?',
                                         selectInput("subjects", NULL, 
                                                     themesW$theme,
                                                     multiple = FALSE),
                                         'Количество курсов рекоммендуемых для прохождения:',
                                         sliderInput("n_rec", label = NULL, min = 0, 
                                                     max = 10, value = 4),
                                         actionButton("done", label = "Готово", icon = NULL, class = "btn-success")),
                            
                            
                            mainPanel(
                              fluidRow(
                                uiOutput("value3"))
                            ))),
                 
                 
                 tabPanel("Login",
                          sidebarLayout(
                            sidebarPanel(
                              'Введите названия курсов, которые Вам понравились:',
                              selectInput("subjects2", NULL, 
                                          cou_with_rev$title,
                                          multiple = TRUE),
                              'Количество курсов рекоммендуемых для прохождения:',
                              sliderInput("n_rec2", label = NULL, min = 0, 
                                          max = 10, value = 4),
                              actionButton("done2", label = "Готово", icon = NULL, class = "btn-success")),
                            
                            mainPanel(
                              fluidRow(
                                uiOutput("value2")
                              )
                            )
                          )))




####################################################################


server <- function(input, output, session) {
  
  ###new user
  output$value3 <- function()({
    input$done
    
    if (input$done > 0){
      
      subjects <- input$subjects
      time <- input$time
      pay <- input$pay
      crsId2 = c()
      rec <- as.data.frame(getColdStart(crsId2, input$subjects, input$time, input$pay,  input$n_rec))
      if (nrow(rec) != 0){
      h = '<style>
      
      .style_prevu_kit
{
    display:inline-block;
    border:0;
    width:200px;
    height:220px;
    position: relative;
    -webkit-transition: all 200ms ease-in;
    -webkit-transform: scale(1); 
    -ms-transition: all 200ms ease-in;
    -ms-transform: scale(1); 
    -moz-transition: all 200ms ease-in;
    -moz-transform: scale(1);
    transition: all 200ms ease-in;
    transform: scale(1);   

}
.style_prevu_kit:hover
{
    box-shadow: 0px 0px 150px #000000;
    z-index: 2;
    -webkit-transition: all 200ms ease-in;
    -webkit-transform: scale(1.5);
    -ms-transition: all 200ms ease-in;
    -ms-transform: scale(1.5);   
    -moz-transition: all 200ms ease-in;
    -moz-transform: scale(1.5);
    transition: all 200ms ease-in;
    transform: scale(1.5);
}
      
      
      </style>'
      for (row in 1:nrow(rec)){
      data = rec[row, ]
      if (data$cover == ""){
        data$cover = "https://pbs.twimg.com/profile_images/1127613794941845504/9zbEcO5y_400x400.jpg"
      }
      course = sprintf('
      <a href="https://stepik.org/course/%s" target="_blank">
      <div class="style_prevu_kit">
      <div style = "height: 200px; weight: 200px; background: white;">
      <img src="%s" hight="200px" width="200px">
      </div>
      <div>
      <h7 style="color: white">%s</h7>
      </div>
      
                </div>
                       </a>', data$id, data$cover, data$title)
      h = paste(h, course)}} 
      
      else{
        h = '<h2 style = "color: white;">К сожалению, таких курсов мы не нашли</h3>'
      }
    
    HTML(h)
    }
  #  if (input$done > 0)
  #  {tbl <- isolate({
  #    
  #    subjects <- input$subjects
  #    time <- input$time
  #    pay <- input$pay
  #    crsId2 = c()
  #    rec <- as.data.frame(getColdStart(crsId2, input$subjects, input$time, input$pay,  input$n_rec))
  #    knitr::kable(rec, "html", col.names = "Курсы для вас:") %>%
  #      kable_styling("striped", full_width = FALSE)
  #   }
  #  )
  #  }
  }
  )
  
  
  
  
  ###login
  output$value2 <- function()({
    input$done2
    
    if (input$done2 > 0){
      
      crsId <- filter(cou_with_rev, title %in% input$subjects2)
      rec2 <- as.data.frame(getCourse(crsId$id, input$n_rec2))
      if (nrow(rec2) != 0){
        h = '<style>
      
      .style_prevu_kit
{
    display:inline-block;
    border:0;
    width:200px;
    height:220px;
    position: relative;
    -webkit-transition: all 200ms ease-in;
    -webkit-transform: scale(1); 
    -ms-transition: all 200ms ease-in;
    -ms-transform: scale(1); 
    -moz-transition: all 200ms ease-in;
    -moz-transform: scale(1);
    transition: all 200ms ease-in;
    transform: scale(1);   

}
.style_prevu_kit:hover
{
    box-shadow: 0px 0px 150px #000000;
    z-index: 2;
    -webkit-transition: all 200ms ease-in;
    -webkit-transform: scale(1.5);
    -ms-transition: all 200ms ease-in;
    -ms-transform: scale(1.5);   
    -moz-transition: all 200ms ease-in;
    -moz-transform: scale(1.5);
    transition: all 200ms ease-in;
    transform: scale(1.5);
}
      
      
      </style>'
        for (row in 1:nrow(rec2)){
          data = rec2[row, ]
          if (data$cover == ""){
            data$cover = "https://pbs.twimg.com/profile_images/1127613794941845504/9zbEcO5y_400x400.jpg"
          }
          course = sprintf('
      <a href="https://stepik.org/course/%s" target="_blank">
      <div class="style_prevu_kit">
      <div style = "height: 200px; weight: 200px; background: white;">
      <img src="%s" hight="200px" width="200px">
      </div>
      <div>
      <h7 style="color: white">%s</h7>
      </div>
      
                </div>
                       </a>', data$id, data$cover, data$title)
          h = paste(h, course)}} 
      
      else{
        h = '<h2 style = "color: white;">К сожалению, таких курсов мы не нашли</h3>'
      }
    HTML(h)
    }
    
  })
  
}
shinyApp(ui = ui, server = server)



