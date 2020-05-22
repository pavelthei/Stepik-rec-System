library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(markdown)
library(knitr)
library(kableExtra)

source("fff.R")

ui <- navbarPage(theme = "https://bootswatch.com/3/cyborg/bootstrap.min.css",
                 #position = "fixed-top",
                 "Stepik RecSys",
                 tabPanel("Home", box("то се пятое десятое", title = "хеллоу", footer = NULL, status = NULL,
                                      solidHeader = FALSE, background = "light-blue", width = 6, height = NULL,
                                      collapsible = FALSE, collapsed = FALSE)),
                 
                 
                 tabPanel("New user",
                          sidebarLayout(
                              sidebarPanel('Готовы ли вы платить за прохождение курса?',
                                           radioButtons("pay", label = NULL,
                                                        choices = list("Да" = TRUE, "Нет" = FALSE), 
                                                        selected = 1),
                                           'Какое количество часов в неделю вы готовы тратить на прохождение курса? (от/до)',
                                           chooseSliderSkin("Flat"),
                                           setSliderColor(c("#31982B","#31982B", "#31982B"), c(1, 2, 3)),
                                           selectInput("time", NULL, 
                                                     cou_with_rev$time_completion ,
                                                     multiple = FALSE),
                                           'По какой теме вы хотели бы пройти курс?',
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
                                  'Введите названия курсов, которые вам понравились:',
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
        
        input <- input$subjects
        time <- input$time
        pay <- input$pay
        
        rec <- as.data.frame(getColdStart(0, input$n_rec))
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
      
      crsId <- filter(cou_with_rev, title == input$subjects2)
      rec2 <- as.data.frame(getCourse(crsId$id, input$n_rec2))
      knitr::kable(rec2, "html", col.names = "Курсы для вас:") %>%
        kable_styling("striped", full_width = FALSE)
      
     })
    }

  })
  
}

shinyApp(ui = ui, server = server)


