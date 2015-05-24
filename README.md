# Getting and Cleaning Data Project Course
This folders contains all files relevant for the completion of the Course Project for the Getting and Cleaning Data module. 

This folder contains:
* 1
* 2
* 3
* 4

The format of the README file is as follows:
* Overivew of project goals
* How the project goals were met
* Detailed approach
* etc

#Overview of project goals

<Taken from the course description website>

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#How the project goals were met

This section describes how each of the individual project goals was met by the current design

####Merges the training and the test sets to create one data set.
The data for the test and train data set was read in turns and the 2 data sets produced were then combined into a single data set using the melting technique described in lectures. Appropriate names were given to each column as the data was loaded in to make it easier to perform the next steps requested. In addition, the Inertials Signal data, although not needed in full length for the final output, was loaded in in the raw format (i.e. all 128 observations from each measurement were loaded)

####Extracts only the measurements on the mean and standard deviation for each measurement. 
####Uses descriptive activity names to name the activities in the data set
####Appropriately labels the data set with descriptive variable names
####From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

