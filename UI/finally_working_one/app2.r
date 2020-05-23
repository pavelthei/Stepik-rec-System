library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(markdown)
library(knitr)
library(kableExtra)

source("futr2.r")

ui <- navbarPage(theme = "https://bootswatch.com/3/cyborg/bootstrap.min.css",
                 #position = "fixed-top",
                 "Stepik RecSys",
                 tabPanel("Home",
                          h3("Привет!", align = "left"),
                          h5("Представляем Вам нашу рекомендательную систему, которая подберет для Вас курсы на Stepik,
исходя из Ваших предпочтений.", align = "left"),
                          br(),
                          h4("Если Вы еще не проходили курсы на Stepik, то выбирайте вкладку «New user»:
проходите небольшой опрос и готовьтесь получать новые знания!", align = "left"),
                          br(),
                          h4("Если же Вы уже были студентом некоторых курсов данной платформы,
то переходите на вкладку «Login», вводите свои любимые курсы, а все остальное мы сделаем за Вас.", align = "left"),
                          br(),
                          h6("Рекомендательную систему сделали:", align = "left"),
                          h5("Елизаров Павел, ОП Экономика;", align = "left"),
                          h5("Леонова Александра, ОП Экономика;", align = "left"),
                          h5("Сергеева Арина, ОП Социология;", align = "left"),
                          h5("Быков Юрий, ОП Менеджмент", align = "left")
                          
                 ),
                 
                 
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
                                tableOutput("value3"))
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
                                tableOutput("value2")
                              )
                            )
                          )))




####################################################################


server <- function(input, output, session) {
  
  ###new user
  output$value3 <- function()({
    input$done
    
    if (input$done > 0) 
    {tbl <- isolate({
      
      subjects <- input$subjects
      time <- input$time
      pay <- input$pay
      crsId2 = c()
      
      rec <- as.data.frame(getColdStart(crsId2, input$subjects, input$time, input$pay,  input$n_rec))
      knitr::kable(rec, "html", col.names = "Курсы для вас:") %>%
        kable_styling("striped", full_width = FALSE)
      
      
    })
    }
  })
  
  
  
  
  ###login
  output$value2 <- function()({
    input$done2
    if (input$done2 > 0) 
    {tbl2 <- isolate({
      
      crsId <- filter(cou_with_rev, title %in% input$subjects2)
      rec2 <- as.data.frame(getCourse(crsId$id, input$n_rec2))
      knitr::kable(rec2, "html", col.names = "Курсы для вас:") %>%
        kable_styling("striped", full_width = FALSE)
      
    })
    }
    
  })
  
}

shinyApp(ui = ui, server = server)



