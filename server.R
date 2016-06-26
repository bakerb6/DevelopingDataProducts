library(shiny)
# read data
df <- read.csv("data/Mesothelioma-data-set.csv", header = TRUE)
# data splitting
library(caret)
library(kernlab)
inTrain <- createDataPartition(y=df$class.of.diagnosis,
                              p=0.75, list=FALSE)
training <- df[inTrain,]
testing <- df[-inTrain,]
# data set categories
patient <- c("age","gender","city")
medicalhistory <- c("asbestos.exposure","duration.of.asbestos.exposure",
                    "duration.of.symptoms","habit.of.cigarette")
symptom <- c("dyspnoea","ache.on.chest","weakness")
diagnosis <- c("diagnosis.method","class.of.diagnosis","pleural.effusion",
               "pleural.thickness.on.tomography")
diagnostic <- c("white.blood","cell.count..WBC.","hemoglobin..HGB.",
                "platelet.count..PLT.","sedimentation",
				        "blood.lactic.dehydrogenise..LDH.","alkaline.phosphatise..ALP.",
                "total.protein","albumin","glucose","pleural.lactic.dehydrogenise",
                "pleural.protein","pleural.albumin","pleural.glucose",
				        "pleural.level.of.acidity..pH.","C.reactive.protein..CRP.")
target <- c("class.of.diagnosis")
# only take columns of interest
trainS <- training[,c(target,medicalhistory,symptom)]
testS <- testing[,c(target,medicalhistory,symptom)]
trainD <- training[,c(target,medicalhistory,diagnostic)]
testD <- testing[,c(target,medicalhistory,diagnostic)]
# fit a model trial one
set.seed(32343)
modelFit1 <- train(as.factor(class.of.diagnosis) ~.,data=trainS, method="glm")
# final model one
finalModel1 <- modelFit1$finalModel
# prediction one
predictions1 <- predict(modelFit1,newdata=testS)
# confusion matrix one
confMatrix1 <- confusionMatrix(predictions1,testS$class.of.diagnosis)
# fit a model trail two
set.seed(32743)
modelFit2 <- train(as.factor(class.of.diagnosis) ~.,data=trainD, method="glm")
# final model two
finalModel2 <- modelFit2$finalModel
# prediction two
predictions2 <- predict(modelFit2,newdata=testD)
# confusion matrix two
confMatrix2 <- confusionMatrix(predictions2,testD$class.of.diagnosis)

shinyServer(
  function(input, output) {
	  output$inputSelect <- renderPrint({
	    if(input$select==1) {
	      c("Symptom: ", symptom)
	    }
	    else {
	      c("Diagnostic test: ", diagnostic)
	    }
	  })
	  # confusion matrix
	  output$resultText <- renderPrint({
	    if(input$select==1) {
	      confMatrix1
	    }
	    else {
	      confMatrix2
	    }
	  })
	  # diagnostic plot
	  output$newDiagPlot <- renderPlot({
	    if(input$select==1) {
	      plot(finalModel1,1,pch=19,cex=0.5,col="#00000010")
	    }
	    else {
	      plot(finalModel2,1,pch=19,cex=0.5,col="#00000010")
	    }
	  })

  }
)
