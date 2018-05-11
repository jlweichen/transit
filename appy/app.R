library("shiny")

ui <- fluidPage(title = "Transit in Chicago - the Shiny App",

  # App title ----
  titlePanel("Transit in Chicago"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(position = "right",

    # Sidebar panel for inputs ----
    sidebarPanel(
      h1("Brrr!")
      h4("This should be text on the side")
      column(
        actionButton("action", "Just a button"),
        textInput("text", h3("Text for entry"), 
                     value = "Enter some words here")

    ),

    # Main panel for displaying outputs ----
    mainPanel(
      h2("pfft pfft")
      br()
      h3("jam")


    )
  )
)
server <- function(input, output) {


  output$distPlot <- renderPlot({



    })

}

shinyApp(ui = ui, server = server)
