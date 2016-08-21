# Set Working Directory.
setwd("/Users/edsonfamily/Desktop/Coursera/3-Getting and Cleaning Data/Project")
getwd()

# Download and Unzip the Dataset.
filename <- "dataset.zip"
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Read Files into R:
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# rbind and cbind alldata into One Dataset.
xall <- rbind(xtrain, xtest)
yall <- rbind(ytrain, ytest)
suball <- rbind(subtrain, subtest)
alldata <- cbind(suball, yall, xall)

# Removing Data No Longer Needed.
rm(xtest,ytest,xtrain,ytrain,subtrain,subtest,xall,yall,suball)  

# Name the Measurement Columns with Feature Names. Give Names to the ID Columns.
featureNames <- as.character(features[,2])
newCols <- c("subject", "activity", featureNames)
colnames(alldata) <- newCols

# Create a new data frame with mean and st. dev.
onlyMeans <- grep("mean()", colnames(alldata))
onlyStDevs <- grep("std()", colnames(alldata))
revisedColumns <- c(onlyMeans, onlyStDevs)
revisedColumns2 <- sort(revisedColumns) 
newDataFrame <- alldata[, c(1,2,revisedColumns2)]
newDataFrame2 <- newDataFrame[, !grepl("Freq", colnames(newDataFrame))] #get rid of the meanFreq columns

# Removing Data No Longer Needed.
rm(newDataFrame, alldata)  

# Trim the rows to the 180 needed to show mean values for each subject-activity pair
tidyframe <- data.frame()
for (i in 1:30) {
    subj<- subset(newDataFrame2,subject==i)
    for (j in 1:6){
        actv<- subset(subj, activity==j)
        myresult<-as.vector(apply(actv,2,mean))
        tidyframe<-rbind(tidyframe,myresult) 
    }
    
}

# Rename columns and output the data to "Tidy_Data.txt"
colnames(tidyframe)<-colnames(newDataFrame2) 
levels(tidyframe[,2])<-c('walk','upstairswalk','downstairswalk', 'sit','stand', 'lay')

#Tidy Data Export
write.table(tidyframe, "Tidy_Data.txt", sep = "", row.names = FALSE)
