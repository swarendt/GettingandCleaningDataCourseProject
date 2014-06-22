## You should create one R script called run_analysis.R that does the following. 

## The data should be located in the directory /UCI HAR Dataset, from there, the
## training data is found in the /Train subdirectory
## and the test data is in the /Test subdirectory
setwd("UCI HAR Dataset")

library(plyr)
library(sqldf)

activity <- read.table("activity_labels.txt")
activity <- rename(activity, c("V1"="ActivityNum","V2"="Activity"))
features <- read.table("features.txt")
features$V2 <- as.character(features$V2)
## features data includes special characters which may cause problems in R functions
features[,2] <- gsub("\\(", "", features[,2])
features[,2] <- gsub("\\)", "", features[,2])
features[,2] <- gsub("\\-", "_", features[,2])
features[,2] <- gsub("\\,", "", features[,2])

##Read in the test data
subject_test <- read.table("test/subject_test.txt")
subject_test <- rename(subject_test, c("V1"="Subject"))
x_test <- read.table("test/x_test.txt")
y_test <- read.table("test/y_test.txt")
y_test <- rename(y_test, c("V1"="Y-ActivityNum"))
##bind it together using column bind for a complete set of the test data.
test_data <- cbind(subject_test, y_test, x_test)

##Read in the training data
subject_train <- read.table("train/subject_train.txt")
## use rename to avoid common column names after column binding
subject_train <- rename(subject_train, c("V1"="Subject"))
x_train <- read.table("train/x_train.txt")
y_train <- read.table("train/y_train.txt")
y_train <- rename(y_train, c("V1"="Y-ActivityNum"))
## Use column bind to come up with the complete set for the training data.
train_data <- cbind(subject_train, y_train, x_train)

##now combine the test data and training data into one data set
all_data <- rbind(test_data, train_data)

all_data <- merge(activity, all_data, by.x="ActivityNum", by.y="Y-ActivityNum", all=TRUE)
colnames(all_data) <- c("ActivityNum", "Activity", "Subject", features[, "V2"])

##any(is.na(all_data))

## create a vector of the columns that include standard deviation or mean in the name
vec <- 2:3
vec <- c(vec, grep("std", colnames(all_data)))
vec <- c(vec, grep("mean", colnames(all_data)))
## then use that vector to get only the data for standard deviation or mean
tidy_data <- all_data[,vec]

## As a SQL programmer, the best option to me is to use the sqldf function to come up with the
## final results.  I fully realize that the point of the exercise may be to use one of the apply
## functions.  
tidy_data_output <- sqldf("select subject, activity
  , AVG(tBodyAcc_std_X), AVG(tBodyAcc_std_Y), AVG(tBodyAcc_std_Z)
  , AVG(tGravityAcc_std_X), AVG(tGravityAcc_std_Y), AVG(tGravityAcc_std_Z)
  , AVG(tBodyAccJerk_std_X), AVG(tBodyAccJerk_std_Y), AVG(tBodyAccJerk_std_Z)
  , AVG(tBodyGyro_std_X), AVG(tBodyGyro_std_Y), AVG(tBodyGyro_std_Z)
  , AVG(tBodyGyroJerk_std_X), AVG(tBodyGyroJerk_std_Y), AVG(tBodyGyroJerk_std_Z)
  , AVG(tBodyAccMag_std)
  , AVG(tGravityAccMag_std)
  , AVG(tBodyAccJerkMag_std)
  , AVG(tBodyGyroMag_std)
  , AVG(tBodyGyroJerkMag_std)
  , AVG(fBodyAcc_std_X), AVG(fBodyAcc_std_Y), AVG(fBodyAcc_std_Z)
  , AVG(fBodyAccJerk_std_X), AVG(fBodyAccJerk_std_Y), AVG(fBodyAccJerk_std_Z)
  , AVG(fBodyGyro_std_X), AVG(fBodyGyro_std_Y), AVG(fBodyGyro_std_Z)
  , AVG(fBodyAccMag_std)
  , AVG(fBodyBodyAccJerkMag_std)
  , AVG(fBodyBodyGyroMag_std)
  , AVG(fBodyBodyGyroJerkMag_std)
  , AVG(tBodyAcc_mean_X), AVG(tBodyAcc_mean_Y), AVG(tBodyAcc_mean_Z)
  , AVG(tGravityAcc_mean_X), AVG(tGravityAcc_mean_Y), AVG(tGravityAcc_mean_Z)
  , AVG(tBodyAccJerk_mean_X), AVG(tBodyAccJerk_mean_Y), AVG(tBodyAccJerk_mean_Z)
  , AVG(tBodyGyro_mean_X), AVG(tBodyGyro_mean_Y), AVG(tBodyGyro_mean_Z)
  , AVG(tBodyGyroJerk_mean_X), AVG(tBodyGyroJerk_mean_Y), AVG(tBodyGyroJerk_mean_Z)
  , AVG(tBodyAccMag_mean)
  , AVG(tGravityAccMag_mean)
  , AVG(tBodyAccJerkMag_mean)
  , AVG(tBodyGyroMag_mean)
  , AVG(tBodyGyroJerkMag_mean)
  , AVG(fBodyAcc_mean_X), AVG(fBodyAcc_mean_Y), AVG(fBodyAcc_mean_Z)
  , AVG(fBodyAcc_meanFreq_X), AVG(fBodyAcc_meanFreq_Y), AVG(fBodyAcc_meanFreq_Z)
  , AVG(fBodyAccJerk_mean_X), AVG(fBodyAccJerk_mean_Y), AVG(fBodyAccJerk_mean_Z)
  , AVG(fBodyAccJerk_meanFreq_X), AVG(fBodyAccJerk_meanFreq_Y), AVG(fBodyAccJerk_meanFreq_Z)
  , AVG(fBodyGyro_mean_X), AVG(fBodyGyro_mean_Y), AVG(fBodyGyro_mean_Z)
  , AVG(fBodyGyro_meanFreq_X), AVG(fBodyGyro_meanFreq_Y), AVG(fBodyGyro_meanFreq_Z)
  , AVG(fBodyAccMag_mean)
  , AVG(fBodyAccMag_meanFreq)
  , AVG(fBodyBodyAccJerkMag_mean)
  , AVG(fBodyBodyAccJerkMag_meanFreq)
  , AVG(fBodyBodyGyroMag_mean)
  , AVG(fBodyBodyGyroMag_meanFreq)
  , AVG(fBodyBodyGyroJerkMag_mean)
  , AVG(fBodyBodyGyroJerkMag_meanFreq)
  from tidy_data group by subject, activity") 

##Write the file out
write.table(tidy_data_output, "tidydata.txt", row.names = FALSE, sep = ",")

##And output the final results for good measure.
tidy_data_output

setwd("..")
