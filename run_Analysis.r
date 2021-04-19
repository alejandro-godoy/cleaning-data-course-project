# Make sure you have moved the following files to the data directory:
# activity_labels, features, subject_test, subject_train, X_test, X_train, y_test, y_train

# Read the text files with the raw data
subject_train <- read.csv("./data/subject_train.txt", header=FALSE)
y_train <- read.csv("./data/y_train.txt", header=FALSE)
X_train <- read.csv("./data/X_train.txt", header = FALSE, sep = "", nrows = 7352, skip = 0, fill = FALSE, strip.white = TRUE, comment.char = "", skipNul = TRUE)
subject_test <- read.csv("./data/subject_test.txt", header=FALSE)
y_test <- read.csv("./data/y_test.txt", header=FALSE)
X_test <- read.csv("./data/X_test.txt", header = FALSE, sep = "", nrows = 2947, skip = 0, fill = FALSE, strip.white = TRUE, comment.char = "", skipNul = TRUE)

# Assign the corresponding label to the activity data sets
library(dplyr)
activity_labels <- read.csv("./data/activity_labels.txt", header=FALSE, sep = "")
y_train_labels <- merge(y_train, activity_labels)
y_test_labels <- merge(y_test, activity_labels)

# Binds the subject and activity data sets
train_data <- cbind(subject_train, y_train_labels)
train_data <- train_data[,-2]
names(train_data) <- c("subject", "activity")
test_data <- cbind(subject_test, y_test_labels)
test_data <- test_data[,-2]
names(test_data) <- c("subject", "activity")

#Assigns column names to the features data set
measurements <- read.csv("./data/features.txt", header=FALSE, sep = "")
names(X_train) <- measurements[,2]
names(X_test) <- measurements[,2]

#Binds the subject, activity and features data sets into a single training and test data set.
complete_train <- cbind(train_data, X_train)
complete_test <- cbind(test_data, X_test)

#Binds the training and test sets into a unified set
complete_set <- rbind(complete_train, complete_test)

#Extracts the mean and std measurements of the unified set
mean_std_cols <- grep("mean\\(|std\\(",measurements$V2)
mean_std_cols <- mean_std_cols + 2
mean_std_cols <- c(1,2,mean_std_cols)
mean_std_set <- complete_set[,mean_std_cols]

#Assigns more descriptive names to the features
names(mean_std_set) <- gsub("\\(\\)(-)+", ".", names(mean_std_set))
names(mean_std_set) <- gsub("\\(\\)$", "", names(mean_std_set))
names(mean_std_set) <- gsub("-", ".", names(mean_std_set))
names(mean_std_set) <- gsub("Acc", "Acceleration", names(mean_std_set))
names(mean_std_set) <- gsub("Mag", "Magnitude", names(mean_std_set))
names(mean_std_set) <- gsub("^t", "Time.", names(mean_std_set))
names(mean_std_set) <- gsub("^f", "Frequency.", names(mean_std_set))

#Generates the final tidy data set with the average of each variable for each activity and each subject
library(reshape2)
library(plyr)
melt_mean_std_set <- melt(mean_std_set, id = c("subject", "activity"), measure.vars = names(mean_std_set[-(1:2)]))
final_tidy_set <- ddply(melt_mean_std_set, .(subject, activity, variable), summarize, average=mean(value))

#Writes the final tidy data set to a file in the data directory
write.table(final_tidy_set, file = "./data/tidy_data_averages.txt", row.names = FALSE, col.names = TRUE)