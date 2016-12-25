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
   
   # Application title
   titlePanel("Smart Text Prediction - SwiftKey Capstone Project"),
   p(strong("This is the final data product for the Coursera - Data Science Specialization Course offered by Johns Hopkins University ")),
   p(strong("This final capstone project is sponsored by SwiftKey")),
   
      # Show a text panel and word predictions
      mainPanel(
         tableOutput(outputId = "predictions"),
         
         textInput(inputId = "phrase",
                   label = "Start writing here",
                   value = "Welcome",
                   width = "100%",
                   placeholder = "Keep typing ..."
                    ),

         p("The software predicts the next word and associated probabilities based on the text input in the text box. The predictions are based on a corpora of blogs, news and tweets. The text corpora provided was analyzed, tokenized,cleaned and converted to n-grams before a dictionary was created. The dictionary is used to make predictions based on frequency of words. We use Markov chains and Stupid Backoff Algos to predict words when phrases and words new to the dictionary are entered.")
 
      )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
            
            output$predictions <-renderTable({
                                inputword<-input$phrase
                                predict_table<-predict_three(word = inputword)
                                t(predict_table)
                                },bordered = T,striped = T,width = "100%",rownames = T,colnames = F
                                )
}

# Run the application 
shinyApp(ui = ui, server = server)

