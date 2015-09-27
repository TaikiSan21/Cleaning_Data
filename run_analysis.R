##  You should create one R script called run_analysis.R that does the following. 

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 

## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Directory that contains the UCI HAR Dataset folder
setwd("~/Coursera/DS Repo/Cleaning_Data/")

## Read in the features
features <- read.table("UCI HAR Dataset/features.txt")
## Create a vector that we will use to name our columns
## Replace () and - with _ to conform to R style standards
## Replace somewhat ambiguous parts of column names with better names
fixedFeat <- gsub("\\()","",features[,2])
fixedFeat <- gsub("-","_",fixedFeat)
fixedFeat <- gsub("^f","freq",fixedFeat)
fixedFeat <- gsub("^t","time",fixedFeat)
fixedFeat <- gsub("Acc","Accel",fixedFeat)
fixedFeat <- gsub("Mag","Magnitude",fixedFeat)

## Read in test and training data. X tables contain the data, so we apply
## the names we made with fixedFeat to each column
Xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=fixedFeat)
Xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=fixedFeat)
## Y tables contain the activity type indicators as 1-6
Ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
Ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
## subject files contain the subject ID
testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
## Load in activity labels that match 1-6 to activity name
actLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## We will filter our data before merging so that we don't merge a giant dataset

## Create a logical vector that is TRUE wherever we have mean or std in
## the column name. We remove the meanFreq values, and we do not get the 
## columns labeled angle(X, gravityMean) because we keep it case-sensitive
meanstd <- as.logical(grepl("mean", fixedFeat) + 
                            grepl("std", fixedFeat) - 
                            grepl("meanFreq", fixedFeat))
## Apply this filter to our test and training sets to get just mean and std cols
Xtest <- Xtest[,meanstd]
Xtrain <- Xtrain[,meanstd]

## Attach subject IDs to test and train sets
Xtest$SubjectID <- testSub$V1
Xtrain$SubjectID <- trainSub$V1

## Replace activity IDs with activity names. We do this by converting the vector
## of activity IDs to a factor variable with the appropriate labels given in the 
## activity_labels.txt
Xtest$ActivityName <- factor(Ytest$V1,labels = actLabels$V2)
Xtrain$ActivityName <- factor(Ytrain$V1, labels=actLabels$V2)

## Merge the two data sets as a data table to facilitate easy calculations
library(data.table)
merged <- data.table(rbind(Xtrain, Xtest))

## Create our tidy dataset, applying the mean function to each column
## and grouping by the SubjectID and ActivityName. Then we order by
## SubjectID for a more logical table ordering
tidyMeans<- merged[, lapply(.SD,mean), by=c("SubjectID","ActivityName")]
tidyMeans<- tidyMeans[order(SubjectID),]

write.table(tidyMeans, "TidyData.txt", row.names=FALSE)