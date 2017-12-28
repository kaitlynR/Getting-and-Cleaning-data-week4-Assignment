library(dplyr)
## read in data sets
train_x <- read.table("X_train.txt")
train_y <- read.table("y_train.txt")
train_subject <- read.table("subject_train.txt")
test_x <- read.table("X_test.txt")
test_y <- read.table("y_test.txt")
test_subject <- read.table("subject_test.txt")

## read variable names
variable_names <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

## combine datasets
X_set <- rbind(train_x, test_x)
Y_set <- rbind(train_y, test_y)
Subject_set <- rbind(train_subject, test_subject)

## assign column names
colnames(X_set) <- variable_names[,2]
colnames(Y_set) <- "activityID"
colnames(Subject_set) <- "subjectID"
colnames(activity_labels) <- c('activityID', 'activity Type')

## merge into one dataset
data_set <- cbind(X_set, Y_set, Subject_set)
col_names <- colnames(data_set)

## create a vector that finds ID, mean and std info
mean_std <- (grepl("activityID", col_names) | grepl("subjectID", col_names) | 
                         grepl("mean..", col_names) | grepl("std..", col_names))


## create a subset of data_set that has only ID, mean and std information
sub_data_set <- data_set[ , mean_std == TRUE]

## add descriptive names
completed_data_set <- merge(sub_data_set, activity_labels, by="activityID", all.x= TRUE)

## create an independent, tidy dataset
tidy_set <- aggregate(. ~subjectID + activityID, completed_data_set, mean)
tidy_set <- tidy_set[order(tidy_set$subjectID, tidy_set$activityID),]

## write as a text file
write.table(tidy_set, "tidy_set.txt", row.names = FALSE)
