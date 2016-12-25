#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(readr)
library(stringi)

source('./Functions/predict_three.R')
source('./Functions/word_backoff.R')



# Define UI for application (just a text box and a table on top for word predicitons).
ui <- fluidPage(
    tags$head(tags$style(
        HTML('
             #sidebar {
             background-color: #ceede5;
             }
             
             body, label, input, button, select { 
             font-family: "Monospace";
             }
             
             #body {
                 background-color: #C0D6E4;
             }
             
             body, label, input, button, select { 
                 font-family: "Times";
                 
             }
             '
             )
  )),
   # Application title
   titlePanel("SMART Predictor - SwiftKey Capstone Project"),
   h4(strong("S"),span("imple   .",style = "color:blue"),strong("M"),span("inimal    .",style = "color:blue"),
      strong("A"),span("ccurate    .",style = "color:blue"),strong("R"),span("esponsive    .",style = "color:blue"),
      strong("T"),span("ext    .",style = "color:blue"), span("Prediction",style = "color:black")),
   p(pre("This final capstone project is sponsored by SwiftKey")),
   sidebarLayout(
       sidebarPanel(
           id="sidebar",
           width = 2,
           p(span("Data Product for the Coursera - Data Science Specialization Course - offered by Johns Hopkins University "),style = "color:blue"),
           hr(),
           p(span(em("The software predicts the next word and associated probabilities based on the text input.")),style = "color:grey"),
           br(),
           p(span(em("The predictions are modeled on a corpora of blogs, news and tweets. The text corpora provided was analyzed, tokenized,cleaned and converted to a minimal n-gram dictionary.")),style = "color:grey"),
           br(),
           p(span(em("This dictionary is used along with Markov Chains and Stupid Backoff methods, to predict when phrases and words new to the dictionary are entered.")),style = "color:grey"),
           hr()
       ),
       
      # Show a text panel and word predictions
      mainPanel(
          id="body",
         tableOutput(outputId = "predictions"),
         
         textInput(inputId = "phrase",
                   label = "Begin Text Input here",
                   value = "Welcome. Keep typing",
                   width = "100%",
                   placeholder = "Keep typing ..."
                    )

         
      )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
            
            output$predictions <-renderTable({
                                inputword<-input$phrase
                                predict_table<-predict_three(word = inputword)
                                t(predict_table)
                                },bordered = T,striped = F,width = "100%",rownames = T,colnames = F
                                )
}

# Run the application 
shinyApp(ui = ui, server = server)

