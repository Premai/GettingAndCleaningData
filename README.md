GettingAndCleaningData
======================

Getting and Cleaning Data Project Assignment Repo

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps already done
In the run_analysis.R have commented out the steps of downloading the zip file and unzipping
as I have uploaded the directory to the GitHub repo.

## Things to consider before running script locally on your desktop
Please download the script run_analysis.R and set the work directory to the folder in which the
R file and data folder (unzipped from the file downloaded) is present.
Also I have named the datafolder as "UCI HAR Dataset", if you have named it different please modify run_analysis.R accordingly before executing.

## To Produce the tidy dataset  
Run the R script run_analysis.R after modifications if any required. 

## Output files are
1. Tidy dataset file DSSmartphonesTidy.txt (tab-delimited text)
2. codebook.md 
3. codebook.html

