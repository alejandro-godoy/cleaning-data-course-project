## Getting and Cleaning Data Course Project Code Book

## Raw Data

The raw data has to be put in a folder called "data" inside the working directory. The necessary
files are the following:

* activity_labels.txt: The ID and description of the activites performed by the subjects (WALKING, STANDING...)
* features.txt: The names of the features related to the measurements taken by the sensors.
* subject_test.txt: The IDs of the subject for each observation of the test set.
* subject_train.txt: The IDs of the subject for each observation of the training set.
* X_test.txt: The measurements (features) of the test set.
* X_train.txt: The measurements (features) of the training set.
* y_test.txt: The IDs of the activities for each observation of the test set.
* y_train.txt: The IDs of the activities for each observation of the training set.

## Reading the data

We use the read.csv function to load the raw data into data frames. Note that we specify the rows and use
additional parameters to make sure the X_train and X_test data is stored correctly.

```
subject_train <- read.csv("./data/subject_train.txt", header=FALSE)
y_train <- read.csv("./data/y_train.txt", header=FALSE)
X_train <- read.csv("./data/X_train.txt", header = FALSE, sep = "", nrows = 7352, skip = 0, fill = FALSE, strip.white = TRUE, comment.char = "", skipNul = TRUE)

subject_test <- read.csv("./data/subject_test.txt", header=FALSE)
y_test <- read.csv("./data/y_test.txt", header=FALSE)
X_test <- read.csv("./data/X_test.txt", header = FALSE, sep = "", nrows = 2947, skip = 0, fill = FALSE, strip.white = TRUE, comment.char = "", skipNul = TRUE)
```

## Processing the data

#### Assign the appropiate labels for the different activities.

With the help of the dplyr package, we merge the activity_labels with the actual data sets 
of training and testing activities (y_train, y_test).

```
library(dplyr)
activity_labels <- read.csv("./data/activity_labels.txt", header=FALSE, sep = "")
y_train_labels <- merge(y_train, activity_labels)
y_test_labels <- merge(y_test, activity_labels)
```


#### Bind the subject and activity data sets

We then bind the activity sets with the subject sets. We get rid of the column that contains the numeric identifier of the activity, and keep only the tex identifier (WALKING, RUNNING, etc).

The resulting data frames are named "train_data" and "test_data", and contain appropriate column names.

```
train_data <- cbind(subject_train, y_train_labels)
train_data <- train_data[,-2]
names(train_data) <- c("subject", "activity")
test_data <- cbind(subject_test, y_test_labels)
test_data <- test_data[,-2]
names(test_data) <- c("subject", "activity")
```


#### Assign column names to the features data set

We make use of the features.txt file to assign column names to the X_train and X_test sets, which contain the 561 features related to each observation.

```
measurements <- read.csv("./data/features.txt", header=FALSE, sep = "")
names(X_train) <- measurements[,2]
names(X_test) <- measurements[,2]
```


#### Bind the subject, activity and features into a single training and test data set.

The data of the user/activity and the features is still separated, so we bind the data into a data set that contains the full train data set (complete_train) and another that contains the full test data set (complete_train).

```
complete_train <- cbind(train_data, X_train)
complete_test <- cbind(test_data, X_test)
```


#### Bind the training and test sets into a unified set

We now bind both training and test sets into a unified set with all the observations.

```
complete_set <- rbind(complete_train, complete_test)
```


#### Extract the mean and std measurements of the unified set

We now extract only those columns that contain the mean and standard deviation for each measurement. First we select only those column names that contain the mean() and std() and then we filter the complete_set into a new mean_std_set that contains only the columns we are interested in.

```
mean_std_cols <- grep("mean\\(|std\\(",measurements$V2)
mean_std_cols <- mean_std_cols + 2
mean_std_cols <- c(1,2,mean_std_cols)
mean_std_set <- complete_set[,mean_std_cols]
```


#### Assigns more descriptive names to the features

In order to make the features more legible, we get rid of parenthesis and hyphens. Also we clarify the meaning of Acc (Acceleration), Mag (Magnitude), t__ (Time) and f__ (Frequency). 

```
names(mean_std_set) <- gsub("\\(\\)(-)+", ".", names(mean_std_set))
names(mean_std_set) <- gsub("\\(\\)$", "", names(mean_std_set))
names(mean_std_set) <- gsub("-", ".", names(mean_std_set))
names(mean_std_set) <- gsub("Acc", "Acceleration", names(mean_std_set))
names(mean_std_set) <- gsub("Mag", "Magnitude", names(mean_std_set))
names(mean_std_set) <- gsub("^t", "Time.", names(mean_std_set))
names(mean_std_set) <- gsub("^f", "Frequency.", names(mean_std_set))
```


#### Generates a tidy data set from the previous one

With the help of the reshape2 package we melt the mean_std_set that contains column names as variables. The columns with mean and std features disappear and instead we have a "variable" column that contains the name of the feature, and a "value" columns that contains the value of the feature measured. These columns are associated to their respective subject and activity, and are stored in the melt_mean_std_set which is now tidy.

```
library(reshape2)
melt_mean_std_set <- melt(mean_std_set, id = c("subject", "activity"), measure.vars = names(mean_std_set[-(1:2)]))
```


#### Generates the final tidy data set with the averages

With the help of the plyr package we generate a data set that contains the average of each variable (feature) for each activity and each subject.

```
library(plyr)
final_tidy_set <- ddply(melt_mean_std_set, .(subject, activity, variable), summarize, average=mean(value))
```


## Storing the processed data

We store the resulting data set in a file called "tidy_data_averages.txt", in the data directory.

```
write.table(final_tidy_set, file = "./data/tidy_data_averages.txt", row.names = FALSE, col.names = TRUE)
```

#### Format of the resulting data

The tidy_data_averages.txt contains the following columns:

* subject: The numeric ID of the subject related to the measurements. 
* activity: The name of the activity performed by the subject while the measurements were taken.
* variable: The name of the specific feature calculated from the measurements taken by the sensors (more information on the features_info.txt file in the original zip containing the raw data).
* average: The average of each feature (variable) for each subject and activity.
