GettingAndCleaningData
======================

Getting and Cleaning Data Project Assignment Repo

##Goal: 
Demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.   
1. a tidy data set   
2. a link to a Github repository with run_analysis.R script for performing the analysis  
3. a code book that describes the variables, the data, and any transformations called CodeBook.md.                      4. README.md that explains how the script work.  

Data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Packages used
knickr

## Files in this repo
README.md -- this is the readme                           
CodeBook.md -- codebook describing variables, the data and transformations          
run_analysis.R --  R code to create tidy data       

## Things to consider before running script locally on your desktop
Please download the script run_analysis.R and set the work directory to the folder in which the
data folder "UCI HAR Dataset" (unzipped from the https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is present.       
The script access the following files in the working directory/UCI HAR Dataset     
* activity_labels.txt       
* features.txt       
* test/     
   Subject_test.txt  
   X_test.txt
   y_test.txt  
* train/     
   Subject_train.txt   
   X_train.txt  
   y_train.txt  
  

## Output files created under the working directory
Tidy dataset file DSSmartphonesTidy.csv (comma separated)  
DSSmartphonesTidy.txt (comma separated)  
codebook.md

##Script Flow
* Read all the test and training files
* Combine the files to a data frame in the form of subjects, labels ...
* Read the features from features.txt and filter it to only leave features that are either means ("mean()") or standard deviations ("std()"). 
* A new data frame is then created that includes subjects, labels and the features.
* Read the activity labels from activity_labels.txt and replace the numbers with the text.
* Make a list of columns (includig "subjects" and "label" at the start)
* Tidy-up the list by removing non-alphanumeric character 
* Apply the new list to the data frame
* Create a new data frame by finding the mean for each combination of subject and label using aggregate() function
* Write the tidied data set to a comma separated csv and txt file.


