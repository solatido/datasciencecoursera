README

run_analysis.R contains the code to complete the course project for Getting and Cleaning Data
as delivered in October, 2014, at https://class.coursera.org/getdata-008

It performs the following tasks:
1. Merges the training and the test sets to create one data set
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set 
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Assumptions:
* UCI HAR Dataset as retrieved Oct. 23, 2014 from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip has been downloaded and unzipped into the current working directory. The current working directory should contain the directory "UCI HAR Dataset"
* The script is set up to run on a linux/apple environment. Windows will require minor modifications to paths or modification to use file.path

