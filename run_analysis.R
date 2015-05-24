#This R script provides the ability to extract, combine, and clean the data as per
#The instructions of the Course Project estabilished by coursera
#An overview of the logic behind each of the transformations steps presented below
#can be found in the ReadMe.md file which should be in the same source as this file

#The first step is to read and combine the two different data sets into a single set
#For this, a helper function get_data_set has been created, please see details of this below

library(plyr)
library(dplyr)

url <- c("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
zip_download <- c("uci_har_dataset.zip")

if(!file.exists(zip_download)) {
        download.file(url, zip_download)
}

folderName <- c("UCI HAR Dataset")

if(!file.exists(folderName)) {
        unzip (zip_download)
}

setwd("UCI HAR Dataset")


#This is the list of all measurements found in the Inertial Signal List
inertial_signal_list <- c("body_gyro_x", "body_gyro_y", 
                          "body_gyro_z", "total_acc_x", "total_acc_y",
                          "total_acc_z","body_acc_x","body_acc_y",
                          "body_acc_z")

inertial_signal_descriptive_names <- c("Angular velocity vector X axis",
                                       "Angular velocity vector Y axis",
                                       "Angular velocity vector Z axis",
                                       "Smartphone acceleration signal X axis",
                                       "Smartphone acceleration signal Y axis",
                                       "Smartphone acceleration signal Z axis",                                       
                                       "Body acceleration signal X axis",
                                       "Body acceleration signal Y axis",
                                       "Body acceleration signal Z axis")
                                       
                                       
                                       

#read the features dataset
features <- read.csv("features.txt", header=FALSE, sep=" ", col.names=c("id","description"), 
                     stringsAsFactors = FALSE)

#The function that will extract the data set based on the parameter that is typed to it
get_data_set <- function(set_type) {
        
        #Read the feature vector from the required set_type
        #temp stores the file location
        #All columns will be numeric and will be given the appropriate names
        temp <- paste(set_type,"/X_",set_type,".txt",sep = "")
        data_set <- read.table(temp, header=FALSE, 
                               colClasses = rep("numeric",nrow(features)), 
                               col.names = features[,2])
        
        ##read the subject list
        temp <- paste(set_type,"/subject_",set_type,".txt",sep="")
        subject_list <- read.table(temp,header=FALSE, colClasses = "numeric", 
                                   col.names="subject_id")
        
        ##read the activities list
        temp <- paste(set_type,"/y_",set_type,".txt",sep="")
        activities_list <- read.table(temp,header=FALSE,colClasses = "numeric", 
                                      col.names="activity_id")
        
        #create a column for specifying which type of set this came from
        #This follows the "melting" principles that have been used in lectures
        data_source <- rep(set_type,nrow(subject_list))
        
        ##add the subject list and the activities list to the data set
        data_set <- cbind(subject_list,activities_list,data_source,data_set)
        
        ##add the Inertial Signal measurements
        for(i in seq_len(length(inertial_signal_list))) {
                
                temp <- paste(set_type,"/Inertial Signals/",inertial_signal_list[i],"_",
                              set_type,".txt",sep="")
                print(temp)
                
                ##read each of the 128 measurements from every file
                temp_data <- read.table(temp,header=FALSE)
                temp_seq <- seq(1:128)
                
                ##Create the column names based on the measurement type plus a number
                temp_col_names <- paste(inertial_signal_list[i],"_",temp_seq,sep="")
                names(temp_data) <- temp_col_names
                
                ##Add the measurements to the data set
                data_set <- cbind(data_set,temp_data)
        }
        
        ##return the data_set
        data_set
        
}

#Get the training and test data sets and combine them into one set
train_set <- get_data_set("train")
test_set <- get_data_set("test")
full_set <- rbind(train_set,test_set)

#Remove unwated objects
rm(train_set)
rm(test_set)

##read the activity labels
activity_labels <- read.table("activity_labels.txt", header=FALSE, 
                              col.names = c("id","description"), stringsAsFactor=FALSE)

#transform the set into a data frame table so that functions from dplyr package can be used
full_set <- tbl_df(full_set)

#The following steps correspond to Step 3 in the project excercise 
#replace the activity_id with activity name
full_set_activities <- select(full_set,activity_id)
full_set_activities <- as.data.frame(full_set_activities)
full_set_activities <- factor(full_set_activities$activity_id)
levels(full_set_activities)= activity_labels[,"description"]
full_set <- mutate(full_set, activity_id = full_set_activities)

#The following steps correspond to Step 2 in the Course Project excercise
#for each type of measurement a meana and a standard deviation will be
#calculated and all the individual measurements will be replaced by these 
#new values. In summary, the 9 measurement types each containing 128 readings
#will be replaced by 9 measurements each having 2 associated values: mean and standard deviation

#loop over the items in the measurement list
for(i in seq_len(length(inertial_signal_list))) {
        
        measurement_type = inertial_signal_list[i]
        
        #get the starting position and end position of the measurements in the data frame table
        start_pos = match(paste(measurement_type,"_1",sep=""), names(full_set))
        end_pos = match(paste(measurement_type,"_128",sep=""), names(full_set))

        #extract the columns for this measurement
        measurement_values <- select(full_set, start_pos:end_pos)

        ##calculate row means and sd 
        mean_measurement <- rowMeans(measurement_values)
        sd_measurement <- apply(measurement_values, 1, sd)
        
        #Store the current names
        current_names <- names(full_set)

        #add the mean and sd to the end of the data frame table
        full_set <- mutate(full_set, temp_mean = mean_measurement)
        full_set <- mutate(full_set, temp_sd = sd_measurement)

        #create the new column names for the computer values
        mean_col_name <- paste(inertial_signal_descriptive_names[i], "_mean",sep="")
        sd_col_name <- paste(inertial_signal_descriptive_names[i], "_sd",sep="")

        #create the vector of new names which contains the previous names plus the names
        #of the 2 new computed values
        new_names <- c(current_names, mean_col_name, sd_col_name)

        #replace the column names of the set with new values
        names(full_set) <- new_names

        #remove measurements that are not needed (the associated 128 readings that now have been summarized)
        full_set <- select(full_set, -(start_pos:end_pos))

}


#Below is the code associated with Step 5 of the cours project requirements
#A new data frame table will be created which will be used to manipulate the data
#according to the steps outlined 

activity_subject <-  full_set

#group by activity_id and subject_id
activity_subject <- group_by(activity_subject, activity_id, subject_id)

#calculate the means for each of the values less the data_source column which is not needed
activity_subject_mean <- summarise_each(activity_subject, funs(mean), -(data_source))

#Add mean.of. in front of every value for which the mean was computed
#This is the final table that will be submitted with the excercise 
current_names <- names(activity_subject_mean)

#Further ehance the descripttion of the variable names by adding "mean.of" at the beggining
#The initial list of features description will be used to compute the new names for the feature vector
means_of_feature_vector <- paste("mean.of.",features[,2],sep="")

#for the measurement mean and sd we will use the names that are already in the dataframe
means_of_measurement_means <- paste("mean.of.", current_names[564:581],sep="")

#create a vector with the new names and apply it to the final output
new_names <- c("Activity Name","Subject ID",means_of_feature_vector, means_of_measurement_means )
names(activity_subject_mean) <- new_names

#write the final output to a text file
final_output <- "finalOutput.txt"
if(file.exists(final_output)) file.remove(final_output)
write.table(activity_subject_mean, final_output, row.name=FALSE)

#revert back to the upper folder 
setwd("..")

#END

