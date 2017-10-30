library(dplyr)
library(reshape)


# read features data
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# read activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

# Get only mean and standard deviation data
featuresRequired <- grep(".*mean.*|.*std.*", features[,2])
featuresRequired.names <- features[featuresRequired,2]

featuresRequired.names = gsub('-mean', 'Mean', featuresRequired.names)
featuresRequired.names = gsub('-std', 'Std', featuresRequired.names)
featuresRequired.names <- gsub('[-()]', '', featuresRequired.names)

# read train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresRequired]
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

train <- cbind(subject_train, Y_train, X_train)

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featuresRequired]
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

test <- cbind(subject_test, Y_test, X_test)



# Merge training and test dataset into one data set
combinedData <- rbind(train, test)
colnames(combinedData) <- c("subject", "activity", featuresRequired.names)

#Update activities and subjects as factors
combinedData$activity <- factor(combinedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
combinedData$subject <- as.factor(combinedData$subject)

combinedData.melted <- melt(combinedData, id = c("subject", "activity"))
combinedData.mean <- data.table::dcast(combinedData.melted, subject + activity ~ variable, mean)

write.table(combinedData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)




