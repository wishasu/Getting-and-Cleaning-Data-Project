## run_analysis.R script is Getting and Cleaning Data project Assignment.

library('reshape2')

##set the workdirect to the samsing dataset folder.
setwd("~/Desktop/Getting and Cleaning Data/UCI HAR Dataset")

##read features and activity_labels, and get the mean and standard deviation of feartures. 
features <- read.table('features.txt')[,2]
feature_need<-grep("mean\\(\\)|std\\(\\)",features)
activity<-read.table("activity_labels.txt",col.names=c("activity.id","activity.name"))

## load data from test folder,clean xtest to get mean and std cols.
xtest <- read.table("test/X_test.txt",col.names= features)[,feature_need]
ytest <- read.table("test/y_test.txt",col.names= c('activity.id'))
subtest <- read.table("test/subject_test.txt",col.names= c('subject'))

## load data from train folder,clean xtrain to get mean and std cols.
xtrain <- read.table("train/X_train.txt",col.names= features)[,feature_need]
ytrain <- read.table("train/y_train.txt",col.names= c('activity.id'))
subtrain <- read.table("train/subject_train.txt",col.names= c('subject'))

## merge test and train dataset,create new dataset that match Assignment 1&2.
data_merge<- cbind(rbind(ytest,ytrain),rbind(subtest,subtrain),rbind(xtest,xtrain))

##use activity names to name the activities in the dataset,match Assignment3.
data_merge<- merge(x=data_merge,y=activity,by="activity.id",all=T)[,-1]

##descriptive variable names to label the dataset,match Assignment4.
names(data_merge)<-gsub("^t", "time", names(data_merge))
names(data_merge)<-gsub("^f", "frequency", names(data_merge))
names(data_merge)<-gsub("Acc", "Accelerometer", names(data_merge))
names(data_merge)<-gsub("Gyro", "Gyroscope", names(data_merge))
names(data_merge)<-gsub("Mag", "Magnitude", names(data_merge))
names(data_merge)<-gsub("BodyBody", "Body", names(data_merge))

## Create and write tidy dataset,match Assignment5
tidyset <- melt(data_merge,id.vars=c("subject",'activity.name'))
tidyset<-dcast(tidyset,subject+activity.name~variable,mean)
write.table(tidyset, file = "tidy.txt", row.names = FALSE)