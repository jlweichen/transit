library("shiny")
library("leaflet")

ui <- fluidPage(title = "Transit in Chicago - the Shiny App",

  # App title ----
  titlePanel("Transit in Chicago"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(position = "right",

    # Sidebar panel for inputs ----
    sidebarPanel(
      h4("Pick your favorite stop")
      column(
        selectInput("var", 
          label = "Choose a variable to display",
          choices = c("O'Hare", "Austin", "Jefferson Park"),
          selected = "Austin"),

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      h2("pfft pfft")
      br()
      h3("jam")
      br()
      textOutput("selected_var")


    )
  )
)
server <- function(input, output) {


  output$distPlot <- renderPlot({



    })

}

shinyApp(ui = ui, server = server)
