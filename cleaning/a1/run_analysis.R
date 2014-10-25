# https://class.coursera.org/getdata-008/human_grading/view/courses/972586/assessments/3/submissions

# The purpose of this project is to demonstrate your ability to collect, work
# with, and clean a data set. The goal is to prepare tidy data that can be used
# for later analysis. You will be graded by your peers on a series of yes/no
# questions related to the project. You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
# 
# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected
# from the accelerometers from the Samsung Galaxy S smartphone. A full
# description is available at the site where the data was obtained:
# 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following. 
#
# 1 Merges the training and the test sets to create one data set
# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 Uses descriptive activity names to name the activities in the data set 
# 4 Appropriately labels the data set with descriptive variable names.
# 5 From the data set in step 4, creates a second, independent tidy data set with the
#   average of each variable for each activity and each subject.

setwd("UCI HAR Dataset")
trainvaluesloc <- "train/X_train.txt"
trainactivityloc <- "train/y_train.txt"
trainsubjectloc <- "train/subject_train.txt"
testvaluesloc <- "test/X_test.txt"
testactivityloc <- "test/y_test.txt"
testsubjectloc <- "test/subject_test.txt"
featuresloc <- "features.txt"
activityloc <- "activity_labels.txt"

# Retrieve and combine test data
test_val <- read.table(testvaluesloc)
test_activity <- read.table(testactivityloc, col.names = "Activity")
test_subjects <- read.table(testsubjectloc, col.names = "Subject")
test <- data.frame(test_subjects, test_activity, Treatment = "test", test_val)

# Retrieve and combine train data
train_val <- read.table(trainvaluesloc)
train_activity <- read.table(trainactivityloc, col.names = "Activity")
train_subjects <- read.table(trainsubjectloc, col.names = "Subject")
train <- data.frame(train_subjects, train_activity, Treatment = "train", train_val)

# 1 Merges the training and the test sets to create one data set

testAndTrain <- rbind(test, train)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.

# Add column names to testAndTrain
features <- read.table(featuresloc, sep=" ", stringsAsFactors = FALSE)
colnames(testAndTrain) <- c(colnames(testAndTrain)[1:3], features$V2)

# Subset by column names including the string "mean()" or "std()"
testAndTrain <- cbind(testAndTrain[1:3],
                      subset(testAndTrain, 
                             select = grepl("mean\\(\\)|std\\(\\)", colnames(testAndTrain))))

# 3 Uses descriptive activity names to name the activities in the data set 

# Turn activity column into factor with levels corresponding to activities
activityNames <- read.table("activity_labels.txt", sep = " ")
testAndTrain$Activity <- as.factor(testAndTrain$Activity)
levels(testAndTrain$Activity) <- activityNames$V2

# 4 Appropriately labels the data set with descriptive variable names.

# Get column names (separate out the Subject/Activity/Treatment ones, they don't need updating)
firstColumns <- colnames(testAndTrain[1:3])
columns <- colnames(testAndTrain[4:length(colnames(testAndTrain))])

# Substitute descriptive strings as described in features_info.txt from the original dataset

# Remove duplicate "Body" substring that appears to be an error in the original column names
columns <- gsub("BodyBody", "Body", columns)
# Perform substutions as described in features_info
columns <- gsub("^t", "Time of ", columns)
columns <- gsub("^f", "Fast Fourier Transform of ", columns)
columns <- gsub("Body", " Body ", columns)
columns <- gsub("Gravity", " Gravity ", columns)
columns <- gsub("Acc", " Accelerometer ", columns)
columns <- gsub("Gyro", " Gyroscope ", columns)
columns <- gsub("Mag", " Magnitude ", columns)
columns <- gsub("mean\\(\\)", " Mean value", columns)
columns <- gsub("std\\(\\)", " Standard deviation", columns)

# Get rid of illegal punctuation introduced in substitutions
columns <- gsub("-", " ", columns)
columns <- gsub(" +", " ", columns)
columns <- make.names(columns)

# Update column names
colnames(testAndTrain) <- c(firstColumns, columns)

# 5 From the data set in step 4, creates a second, independent tidy data set with the
#   average of each variable for each activity and each subject.

# Get mean of each variable for each subject/activity combination
avPerSubjectAndActivity <- aggregate(testAndTrain[4:length(colnames(testAndTrain))],
                                     by=list(testAndTrain$Subject, testAndTrain$Activity),
                                     FUN = mean)
# Fix column names
colnames(avPerSubjectAndActivity) <- c("Subject", "Activity",
                                       paste("Overall.Mean", colnames(avPerSubjectAndActivity)[3:length(colnames(avPerSubjectAndActivity))], sep = "."))

# Write out averages to file
setwd("..")
write.table(avPerSubjectAndActivity, "harAverages.txt")