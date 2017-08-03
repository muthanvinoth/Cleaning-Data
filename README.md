# Reproducible Research: Peer Assessment 1



## Loading packages and preprocessing the data


```r
library(plyr) 
# Function to pre-process data
Readf <- function(fname,features) {
  
  #Reading data to variable, 
  
  sData    <-read.table(gsub('xyz',fname, "./xyz/subject_xyz.txt"), header=FALSE)
  xData          <- read.table(gsub('xyz',fname,"./xyz/X_xyz.txt"), header=FALSE)
  yData          <- read.table(gsub('xyz',fname,"./xyz/y_xyz.txt"), header=FALSE)
  
  #Assign column names to the data above.
  colnames(sData) <- "subject"
  colnames(xData) <- features[,2]
  colnames(yData) <- c("activityId")

  #Merging Data to result...
  
  result <- cbind(yData,sData,xData)
  
}
```




## 1. Merge the training and the test data


```r
# load common dataset.
features        <- read.table("./features.txt",header=FALSE)
activityLabel   <- read.table("./activity_labels.txt",header=FALSE)
colnames(activityLabel)<-c("activityId","activityType")


#load specific dataset.

trainData<-Readf('train',features)
testData<-Readf('test',features)

finalData <- rbind(trainData,testData)
```

## 2. Extract only the measurements on the mean and standard deviation for each measurement

```r
colNames <- colnames(finalData);

# extract columns by grep
data_mean_std <-finalData[,grepl("mean|std|subject|activity",colnames(finalData))]
```
## 3. #Uses descriptive activity names to name the activities in the data set

```r
data_mean_std<- merge(x=data_mean_std, y=activityLabel, by="activityId")
```


## 4. Appropriately labels the data set with descriptive variable names.
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)



```r
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
```
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




```r
tidydata_average_sub<- ddply(data_mean_std, c("subject","activityType"), numcolwise(mean))

write.table(tidydata_average_sub,file="tidydata.txt")
```

