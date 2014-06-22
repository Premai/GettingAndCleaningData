#set the UCI HAR Dataset as path to be run from under Github
path <- setwd(getwd())

#download the zip file to the current working directory as the file is already downloaded and
#unzipped commented the below steps 

#url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#f <- "HARDataset.zip"
#if (!file.exists(path)) {
#  dir.create(path)
#}
#download.file(url, file.path(path, f))

#Steps to unzip the zip file commenting this as i have uploaded the folder

#executable <- file.path("C:", "Program Files", "7-Zip", "7z.exe")
#parameters <- "x"
#cmd <- paste(paste0("\"", executable, "\""), parameters, paste0("\"", file.path(path, f), "\""))
#system(cmd)

pathIn <- file.path(path, "UCI HAR Dataset")

#Read Subject Files from train and test folders respectively under UCI HAR DATASET folder
dfSubjectTrain <- fread(file.path(pathIn, "train", "subject_train.txt")) 
dfSubjectTest <- fread(file.path(pathIn, "test", "subject_test.txt")) 

#Read Activity Files from train and test folders respectively under UCI HAR DATASET folder
dfActivityTrain <- fread(file.path(pathIn, "train", "Y_train.txt")) 
dfActivityTest <- fread(file.path(pathIn, "test", "Y_test.txt")) 

#Read Data Files x_train and x_test from train and test folders respectively 
#under UCI HAR DATASET folder
fileToDataTable <- function(f) {
  df <- read.table(f)
  dt <- data.table(df)
}
#convert to data table form
dtTrain <- fileToDataTable(file.path(pathIn, "train", "X_train.txt"))
dtTest <- fileToDataTable(file.path(pathIn, "test", "X_test.txt"))

#Merging the training and the test sets
#concatenate the tables
#set meaningful name
dtSubject <- rbind(dfSubjectTrain, dfSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivity <- rbind(dfActivityTrain, dfActivityTest)
setnames(dtActivity, "V1", "activityNum")
dt <- rbind(dtTrain, dtTest)

#Merge columns
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

#Set key
setkey(dt, subject, activityNum)

#Extract only the mean and standard deviation
dtFeatures <- fread(file.path(pathIn, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))

#Subset only measurements for the mean and standard deviation.
dtFeatures <- dtFeatures[grepl("mean\\(\\)|std\\(\\)", featureName)]

#Convert the column numbers to a vector of variable names matching columns in dt
dtFeatures$featureCode <- dtFeatures[, paste0("V", featureNum)]
head(dtFeatures)
dtFeatures$featureCode

#Subset these variables using variable names
select <- c(key(dt), dtFeatures$featureCode)
dt <- dt[, select, with = FALSE]

#Use descriptive activity names
dtActivityNames <- fread(file.path(pathIn, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

#Merge activity labels
dt <- merge(dt, dtActivityNames, by = "activityNum", all.x = TRUE)

#Add activityname as key
setkey(dt, subject, activityNum, activityName)

#reshape data table
dt <- data.table(melt(dt, key(dt), variable.name = "featureCode"))

#merge activity name
dt <- merge(dt, dtFeatures[, list(featureNum, featureCode, featureName)], by = "featureCode", 
            all.x = TRUE)

#recreate activityname and featurename as a factor class
dt$activity <- factor(dt$activityName)
dt$feature <- factor(dt$featureName)

#Separate features and make them redundant
grepthis <- function(regex) {
  grepl(regex, dt$feature)
}
## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("^t"), grepthis("^f")), ncol = nrow(y))
dt$featDomain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(grepthis("Acc"), grepthis("Gyro")), ncol = nrow(y))
dt$featInstrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepthis("BodyAcc"), grepthis("GravityAcc")), ncol = nrow(y))
dt$featAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
x <- matrix(c(grepthis("mean()"), grepthis("std()")), ncol = nrow(y))
dt$featVariable <- factor(x %*% y, labels = c("Mean", "SD"))
## Features with 1 category
dt$featJerk <- factor(grepthis("Jerk"), labels = c(NA, "Jerk"))
dt$featMagnitude <- factor(grepthis("Mag"), labels = c(NA, "Magnitude"))
## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(grepthis("-X"), grepthis("-Y"), grepthis("-Z")), ncol = nrow(y))
dt$featAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

#Make sure all possible combinations of features are accountable
r1 <- nrow(dt[, .N, by = c("feature")])
r2 <- nrow(dt[, .N, by = c("featDomain", "featAcceleration", "featInstrument", 
                           "featJerk", "featMagnitude", "featVariable", "featAxis")])
r1 == r2

#Create Tidy Dataset
setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, 
       featJerk, featMagnitude, featVariable, featAxis)
dtTidy <- dt[, list(count = .N, average = mean(value)), by = key(dt)]

#f <- file.path(path, "DSSmartphonesTidy.txt")
#write.table(dtTidy, f, quote = FALSE, sep = "\t", row.names = FALSE)

#Make codebook
knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)

#Create html format
markdownToHTML("codebook.md", "codebook.html")