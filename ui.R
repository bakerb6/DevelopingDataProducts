# Diagnosis of Mesothelioma disease

library(shiny)
shinyUI(
  pageWithSidebar(
    # Application title
    headerPanel("Mesothelioma prediction"),
    sidebarPanel(
      h3("Feature selection"),
      p("Choose by symptom or diagnostic test."),
      selectInput("select", label = h4("Select box"),
      choices = list("Symptom" = 1, "Diagnostic test" = 2),
          selected  = 1),
      submitButton('Submit')
	  ), 
    mainPanel(
      h3('Results of prediction for class of diagnosis Healthy or Diseased'),
      h4('You selected'),
      verbatimTextOutput("inputSelect"),
      h4('Which resulted in a prediction of '),
      verbatimTextOutput("resultText"),
      h4('Diagnostic Plot'),
      plotOutput('newDiagPlot'),
      br(),
      p("Reference"),
      p("An approach based on probabilistic neural network for diagnosis of Mesothelioma's disease", 
        "By: Er, Orhan; Tanrikulu, Abdullah Cetin; Abakay, Abdurrahman; et al. ",
        "COMPUTERS & ELECTRICAL ENGINEERING Volume: 38 Issue: 1 Pages: 75-81 Published: JAN 2012 ")
    )
  )
)
