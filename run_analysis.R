library(dplyr)

theFile <- "thefile.zip"

if (!file.exists(theFile)){
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = theFile)
}

if (!file.exists("UCI HAR Dataset")) { 
  unzip(theFile) 
}

x_train = read.table(".\\UCI HAR Dataset\\train\\X_train.txt",strip.white = TRUE)
y_train = read.table(".\\UCI HAR Dataset\\train\\y_train.txt",strip.white = TRUE)
subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt",strip.white = TRUE)

x_test = read.table(".\\UCI HAR Dataset\\test\\X_test.txt",strip.white = TRUE)
y_test = read.table(".\\UCI HAR Dataset\\test\\y_test.txt",strip.white = TRUE)
subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt",strip.white = TRUE)

features = read.table(".\\UCI HAR Dataset\\features.txt",strip.white = TRUE)


x_appended <- rbind(x_train, x_test)
y_appended <- rbind(y_train, y_test)

subject_appended <- rbind(subject_train,subject_test)




activity_labels = read.table(".\\UCI HAR Dataset\\activity_labels.txt",strip.white = TRUE)$V2
y_appended[,1] = activity_labels[y_appended[,1]]

names(y_appended) <- "Activity"
names(subject_appended) <- "Subject"
names(x_appended)<-features$V2



combined_data_total <- cbind(x_appended,y_appended,subject_appended)
sub_features <- features[grep("mean|std", features[,2]),2]
combined_data <- subset(combined_data_total, select = c(grep("mean|std", features[,2]),562,563))


means_data <- ddply(combined_data, .(Subject, Activity), function(x) colMeans(x[, 1:79]))
write.table(means_data, "tidy.txt", row.name=FALSE)