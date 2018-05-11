library("shiny")
library("leaflet")

ui <- fluidPage(
                
                # App title ----
                titlePanel("Transit in Chicago"),
                
                # Sidebar layout with input and output definitions ----
                sidebarLayout(position = "right",
                              
                              # Sidebar panel for inputs ----
                              sidebarPanel(
                                fluidRow(
                                  h4("Pick your favorite stop")
                                ),
                                fluidRow(
                                  column(12,
                                  selectInput("station", 
                                              label = "Choose Below",
                                              choices = c("O'Hare", "Rosemont", "Cumberland", "Harlem (O'Hare Branch)", "Austin", "Jefferson Park", ""),
                                              selected = "Austin")
                                  )
                                )
                              ),

                                # Main panel for displaying outputs ----
                              mainPanel(
                                  h4("A map of tweets near your stop"),
                                  br(),
                                  textOutput("maptitle")

                                )
                              )
                )
                server <- function(input, output) {
                  
                  output$maptitle <- renderText({
                    paste('This is the ', input$station, ' station')
                  })
                }
                
                shinyApp(ui = ui, server = server)
