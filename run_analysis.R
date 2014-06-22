#Load package knitr
library(knitr)

#set the UCI HAR Dataset as path 
path <- setwd(getwd())
pathIn <- file.path(path, "UCI HAR Dataset")

#Read Subject Files from train and test folders respectively under UCI HAR DATASET folder
dtSubjectTrain <- read.table(file.path(pathIn, "train", "subject_train.txt"), col.names="subject")
dtSubjectTest  <- read.table(file.path(pathIn, "test", "subject_test.txt"), col.names="subject")

#Read label Files from train and test folders respectively under UCI HAR DATASET folder
dtlabelsTrain <- read.table(file.path(pathIn, "train", "Y_train.txt"), col.names="label")
dtlabelsTest  <- read.table(file.path(pathIn, "test", "Y_test.txt"), col.names="label") 

#Read Data Files x_train and x_test from train and test folders respectively 
dtTrainData <- read.table(file.path(pathIn,"train", "X_train.txt"))
dtTestData  <- read.table(file.path(pathIn,"test", "X_test.txt"))

#Merge data sets
data <- rbind(cbind(dtSubjectTest, dtlabelsTest, dtTestData),
              cbind(dtSubjectTrain, dtlabelsTrain, dtTrainData))

#Extract only the mean and standard deviation
dtFeatures <- read.table(file.path(pathIn, "features.txt"),strip.white=TRUE,stringsAsFactors=FALSE)
dtFeatures.mean.std <- dtFeatures[grep("mean\\(\\)|std\\(\\)", dtFeatures$V2), ]
# eliminate subjects and labels in the beginning
data.mean.std <- data[, c(1, 2, dtFeatures.mean.std$V1+2)]

# read the labels (activities)
labels <- read.table(file.path(pathIn,"activity_labels.txt"), stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]

# tidy list by removing non-alphabetic character 
tidy.colnames <- c("subject", "label",dtFeatures.mean.std$V2)
tidy.colnames <- gsub("[^[:alpha:]]", "", tidy.colnames)
# Assign as column names for data
colnames(data.mean.std) <- tidy.colnames

#Compute Mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       FUN=mean)

# write the data 
f <- file.path(path, "DSSmartphonesTidy.txt")
write.table(aggr.data, f, row.names=F, sep = ",",quote=F)

fc <- file.path(path, "DSSmartphonesTidy.csv")
write.table(aggr.data, fc, row.names=F, sep = ",",quote=F)


#Make codebook
knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)