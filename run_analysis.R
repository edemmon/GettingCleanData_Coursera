#This is a project for Getting and Cleaning Data created by estorm on 1/28/18

#Step 1) Set up the proper working directory and load the libraries
setwd("~/R/UCI HAR Dataset/")
library(data.table)
library(dplyr)

#Step 2) Bring in your data
activityLabel <- read.table("./activity_labels.txt")[,2]
features <- read.table("./features.txt")[,2]
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

#Step 3) apply labels
names(X_test) = features
y_test[,2] = activityLabel[y_test[,1]]
names(y_test) = c("activity_id", "activity_label")
names(subject_test) = "subject"
names(X_train) = features
y_train[,2] = activityLabel[y_train[,1]]
names(y_train) = c("activity_id", "activity_label")
names(subject_train) = "subject"

#Step 4) identify data we want to extract
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

#Step 5) Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

data = rbind(test_data, train_data)

id_labels   = c("subject", "activity_id", "activity_label")
data_labels = setdiff(colnames(data), id_labels)
finaldata     = melt(data, id = id_labels, measure.vars = data_labels)

#create  a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data   = dcast(finaldata , subject + activity_label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")