library(shiny)

ui <- navbarPage(theme = "https://bootswatch.com/3/cyborg/bootstrap.min.css",
                 #position = "fixed-top",
                 "Stepik RecSys",
                 tabPanel("Home"),
                 
                 
                 tabPanel("New user",
                          sidebarLayout(
                              sidebarPanel('Готовы ли вы платить за прохождение курса?',
                                           radioButtons("pay", label = NULL,
                                                        choices = list("Да" = 1, "Нет" = 0), 
                                                        selected = 1),
                                           'Какое количество часов в неделю вы готовы тратить на прохождение курса? (от/до)',
                                           sliderInput("time", label = NULL, 
                                                       min = 0, max = 50, 
                                                       value = c(15, 35)),
                                           'По какой теме вы хотели бы пройти курс?',
                                           selectInput("theme", NULL, 
                                                       c("Design" = "design", "Coding" = "coding", "Painting" = "painting"),
                                                         multiple = TRUE),
                                           'Количество курсов рекоммендуемых для прохождения:',
                                           sliderInput("slider1", label = NULL, min = 0, 
                                                       max = 10, value = 4),
                                           actionButton("done", label = "Готово", icon = NULL)),
                                           
                              mainPanel())),
                 
                 
                 tabPanel("Login",
                          sidebarLayout(
                              sidebarPanel(
                                  'Введите названия курсов, которые вам понравились:',
                                  selectInput("theme", NULL, 
                                              c("a" = "a", "b" = "b", "c" = "c"),
                                              multiple = TRUE),
                                  'Количество курсов рекоммендуемых для прохождения:',
                                  sliderInput("slider1", label = NULL, min = 0, 
                                              max = 10, value = 4),
                                  actionButton("done", label = "Готово", icon = NULL)),
                              mainPanel()
                          ))
                 )
                










####################################################################
# Define server logic required to draw a histogram
server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)
