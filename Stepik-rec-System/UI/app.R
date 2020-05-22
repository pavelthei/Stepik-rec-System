library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(markdown)
library(knitr)
library(kableExtra)


# source("cold.R")
# source("warm.R")

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
                                                        choices = list("Да" = 1, "Нет" = 0), 
                                                        selected = 1),
                                           'Какое количество часов в неделю вы готовы тратить на прохождение курса? (от/до)',
                                           chooseSliderSkin("Flat"),
                                           setSliderColor(c("#31982B","#31982B", "#31982B"), c(1, 2, 3)),
                                           sliderInput("time", label = NULL, 
                                                       min = 0, max = 50, 
                                                       value = c(15, 35)),
                                           'По какой теме вы хотели бы пройти курс?',
                                           selectInput("subjects", NULL, 
                                                        c("a", "b"),#data$labels,
                                                         multiple = TRUE),
                                           'Количество курсов рекоммендуемых для прохождения:',
                                           sliderInput("n_rec", label = NULL, min = 0, 
                                                       max = 10, value = 4),
                                           actionButton("done", label = "Готово", icon = NULL, class = "btn-success")),
                              
                                           
                              mainPanel(
                                fluidRow(
                                verbatimTextOutput("value"))
                              ))),
                 
                 
                 tabPanel("Login",
                          sidebarLayout(
                              sidebarPanel(
                                  'Введите названия курсов, которые вам понравились:',
                                  selectInput("subjects2", NULL, 
                                              coursesmult$title,
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

server <- function(input, output) {
  
  ###new user
  output$value <- renderPrint({
    input$done
    
    tbl <- isolate({
      c(input$pay, input$time, input$subjects, input$n_rec)
    })
    tbl
  })
  

  
  ###login
  output$value2 <- function()({
    input$done2
    if (input$done2 > 0) 
    {tbl <- isolate({
      crsId <- filter(coursesmult, title == input$subjects2)
      rec <- as.data.frame(getCourses(crsId$id, input$n_rec2))
      knitr::kable(rec, "html", col.names = "Курсы для вас:") %>%
        kable_styling("striped", full_width = FALSE)
    })
    }

  })
  
}

shinyApp(ui = ui, server = server)
