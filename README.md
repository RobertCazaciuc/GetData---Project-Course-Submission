# Getting and Cleaning Data Project Course
This folders contains all files relevant for the completion of the Course Project for the Getting and Cleaning Data module. 

This folder contains:
* run_analysis.R file that will be used to perform the analysis
* README.md Markdown file describing the approach and considerations
* CodeBook.md Markdown file describing the variables and readings

The format of the README file is as follows:
* Overivew of project goals
* How the project goals were met
* How to read the final table

Please note that a detailed description of the steps performed in run_analysis.R was included in the R file itself. The detailed walktrough of the code was left of this document but a summary is provided.

However, it is worth mentioning here that the code has been fully automated to download the zip file from the URL provided and extract the data in the current working directory of the user. This also include cheks that allows for multiple runs of the script without any problems.

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
The data for the test and train data set were read in turns and the 2 data sets produced were then combined into a single data set using the melting technique described in lectures. Appropriate names were given to each column as the data was loaded in to make it easier to perform the next steps requested. In addition, the Inertials Signal data, although not needed in full length for the final output, was loaded in in the raw format (i.e. all 128 observations from each measurement were loaded)

The merged data set contained the following columns:
* Subject ID
* Activity ID
* Data Source (test or train)
* 561 columns representing the feature vector readings
* 9 x 128 columns representing the 128 readings for each measurement as part of the Inertials Signal Data

####Extracts only the measurements on the mean and standard deviation for each measurement.
As mentioned previously, all 128 readings from each of the measurements were loaded in the raw format but given according column names (i.e. the readings from body_acc_x_test were labelled body_acc_x_test_1 through body_acc_x_test_128). The mean and standard deviation for each measurement was then computed and added to the end of the data set with appropriate column names. Finally, the 128 x 9 raw entries for all measurements were removed from the data set.

The data set contained the following columns following this step:
* Subject ID
* Activity ID
* Data Source (test or train)
* 561 columns representing the feature vector readings
* 9 x 2 columns representing the mean and standard deviation for each of the 9 measurements

####Uses descriptive activity names to name the activities in the data set
To achieve this task the Activity ID column from the data set was first turned into a factor format. After that the levels were changed to match the descriptive activity name as described in the "activity_labels.txt" file available from the data set. The description of the activity names available were considered to be clear for the purpose of this excercise and required no additional alterations. 

####Appropriately labels the data set with descriptive variable names
A full description of variable names can be found in the CodeBook.md file available in the same repository location as this file. Below, a summary of the descriptive names and reasoning can be found:

* Activity Name - self explanatory
* Subject ID - self explanatory
* Data Source - information regarding where the data was read from (not used in the final output)
* 561 feature vector names as described in the features.txt file available. The topic of further modifying the description of these variables is subject to debate and there certainly multiple possibilities. The approach preferred in this solution is to keep the name of the features as defined in the source file. The main reason behind this is that further modifying the description can add additional confusion to the already complicated calculations being used here. In addition, this format allows for the feature vector column names to be referenced in the original documentation as no significant alternations are made. This reasoning was also supported by additional students in the course project forum. Please see more details here:
https://class.coursera.org/getdata-014/forum/thread?thread_id=30
* 9 * 2 description values for the mean and standard deviation calculations based on the following format examples
"Angular velocity vector X axis_mean", "Angular velocity vector X axis_sd", etc. Full list can be found in the CodeBook.md file

####From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
To create the final data set the following steps were taken: 
* The data.frame table computed in previous excercises was trasnsformed into a data frame table object to bused with the ddplyr package
* The group_by function was then used to group the variables by Activity and Subject
* A mean function was applied to all columns available in the data set, minus Activity, Subject ID and Data Source. The summarize_each function was used to achieve this
* Finally, each of the mean calculated values was added with a "mean.of." in front of the descriptive variable name to reflect the changes

#How to read the final table
Steps:
* data <- read.table("UCI HAR Dataset/finalOutput.txt", header=TRUE)
* View(data)
