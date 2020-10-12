#peer reviewed assignment
setwd("C:/Users/delik/Downloads/data/R/coursera data science course/course 2 data cleaning/peer reviewed assignment")
library(dplyr)

filename <- "peer reviewed assignment raw dataset.zip"

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename)
}  


if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, Y, X)
a<-select(merged,subject, code, contains("mean"), contains("std"))

#step 3 : Uses descriptive activity names to name the activities in the data set
a$code<-activities[a$code,2]

#step 4 : Appropriately labels the data set with descriptive variable names.
names(a)[2] <- "activity"
names(a)<-gsub(pattern="Acc", replacement="Accelerometer", names(a))
names(a)<-gsub("Gyro", "Gyroscope", names(a))
names(a)<-gsub("BodyBody", "Body", names(a))
names(a)<-gsub("Mag", "Magnitude", names(a))
names(a)<-gsub("^t", "Time", names(a))
names(a)<-gsub("^f", "Frequency", names(a))
names(a)<-gsub("tBody", "TimeBody", names(a))
names(a)<-gsub("-mean()", "Mean", names(a), ignore.case = TRUE)
names(a)<-gsub("-std()", "STD", names(a), ignore.case = TRUE)
names(a)<-gsub("-freq()", "Frequency", names(a), ignore.case = TRUE)
names(a)<-gsub("angle", "Angle", names(a))
names(a)<-gsub("gravity", "Gravity", names(a))

#step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
final <- a %>%   group_by(subject, activity) %>%   summarise_all(.funs=mean)
write.table(final, "final.txt", row.name=FALSE)

