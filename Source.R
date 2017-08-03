# Load packages we are going to work with

library(dplyr)          # Working with tables

#1. Merge the training and the test data.


#reading the data general and training.

features        <- read.table("./features.txt",header=FALSE)
activityLabel   <- read.table("./activity_labels.txt",header=FALSE)
colnames(activityLabel)<-c("activityId","activityType")

Readf <- function(fname,features) {
  
  sData    <-read.table(gsub('xyz',fname, "./xyz/subject_xyz.txt"), header=FALSE)
  xData          <- read.table(gsub('xyz',fname,"./xyz/X_xyz.txt"), header=FALSE)
  yData          <- read.table(gsub('xyz',fname,"./xyz/y_xyz.txt"), header=FALSE)
  
  
  #Assign column names to the data above.
  
  
  colnames(sData) <- "subject"
  colnames(xData) <- features[,2]
  colnames(yData) <- c("activityId")

  
  
  #Merging training Data...
  
  result <- cbind(yData,sData,xData)
  
}

trainData<-Readf('train',features)
testData<-Readf('test',features)






#final merged data

finalData <- rbind(trainData,testData)

# creating a vector for column names to be used further

colNames <- colnames(finalData);



# 2. Extract only the measurements on the mean and standard deviation for each measurement


data_mean_std <-finalData[,grepl("mean|std|subject|activity",colnames(finalData))]



#3. #Uses descriptive activity names to name the activities in the data set


data_mean_std<- merge(x=data_mean_std, y=activityLabel, by="activityId")

#4. Appropriately labels the data set with descriptive variable names.

#Remove parentheses

names(data_mean_std) <- gsub("\\(|\\)", "", names(data_mean_std), perl  = TRUE)

#correct syntax in names

names(data_mean_std) <- make.names(names(data_mean_std))

#add descriptive names


names(data_mean_std) <- gsub("^t", "Time.", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Freq.", names(data_mean_std))
names(data_mean_std) <- gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std) <- gsub("mean", "Mean", names(data_mean_std))
names(data_mean_std) <- gsub("std", "Std", names(data_mean_std))



#creates a second, independent tidy data set with the average of each variable for each activity and each subject.


tidydata_average_sub<- ddply(data_mean_std, c("subject","activityType"), numcolwise(mean))

write.table(tidydata_average_sub,file="tidydata.txt",row.names = FALSE)

