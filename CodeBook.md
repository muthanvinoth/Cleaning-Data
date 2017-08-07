# Getting and Cleaning Data

### Data Set Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 


###Attribute Information:

For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


### Objective

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


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
After setting the source directory for the files, read into tables the data located in
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

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
## 3. Use descriptive activity names to name the activities in the dataset

Merge data subset with the activityType table to inlude the descriptive activity names

```r
data_mean_std<- merge(x=data_mean_std, y=activityLabel, by="activityId")
```


##4. Appropriately labels the data set with descriptive variable names.
1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)



```r
#Remove parentheses

names(data_mean_std) <- gsub("\\(|\\)", "", names(data_mean_std), perl  = TRUE)

#correct syntax in names

names(data_mean_std) <- make.names(names(data_mean_std))

#add descriptive names
Use gsub function for pattern replacement to clean up the data labels.

names(data_mean_std) <- gsub("^t", "Time.", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Freq.", names(data_mean_std))
names(data_mean_std) <- gsub("BodyBody", "Body", names(data_mean_std))
names(data_mean_std) <- gsub("mean", "Mean", names(data_mean_std))
names(data_mean_std) <- gsub("std", "Std", names(data_mean_std))
```
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
we need to produce only a data set with the average of each veriable for each activity and subject



```r
tidydata_average_sub<- ddply(data_mean_std, c("subject","activityType"), numcolwise(mean))

write.table(tidydata_average_sub,file="tidydata.txt",row.names = FALSE)
```

