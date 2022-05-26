library(shiny)
library(shinydashboard)
library(dplyr)
library("shinymaterial")

ui <- dashboardPage(
  dashboardHeader(dropdownMenuOutput("notificationMenu")),
  dashboardSidebar(sidebarMenu(menuItem("Page 1", tabName = "page1"),
                               menuItem("Page 2", tabName = "page2"))),
  dashboardBody(tabItems(
    tabItem(tabName = "page1", h4("This is Page 1"),
            material_floating_button(
              input_id = "example_floating_button",
              icon = "live_help",
              depth = 5,
              color = "red lighten-3"
            )),
    tabItem(tabName = "page2",
            textInput("text", "Enter News:", "New News."),
            actionButton("save", "Save"))
  )))

server <- function(input, output, session){
  raw_news <- reactiveValues()

  # Intial Header News: 1 Message from Admin
  raw_news$news <- data_frame(from = "Admin", text = "this is a message")

  # The notifications in header
  output$notificationMenu <- renderMenu({
    raw_news <- raw_news$news

    dropdownMenu(
      messageItem(raw_news$from[1], raw_news$text[1])
    )
  })

  # save a new notification
  observeEvent(input$save, {
    raw_news$news <- data.frame(from = "User", text = input$text)
  })
}

shinyApp(ui = ui, server = server)
