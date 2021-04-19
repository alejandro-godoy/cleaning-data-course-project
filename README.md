## Getting and Cleaning Data Course Project

This repository contains the necessary material to accomplish the goals of the Getting 
and Cleaning Data Course Project. 

The data utilized can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

These files contain 561 different measurements obtained by sensors in a Samsung Smartphone. The
measurements were taken to 30 different subjects while performing 6 different activities (WALKING, 
STANDING, etc). There are separate data sets for training and test purposes. A full description of the 
data is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Project structure

### Data files 

The source code assumes that there is a data folder right under the working directory. For 
example: C://{my_working_directory}/data. The data folder contains the following files, which
can be obtained from the link above:

* activity_labels.txt: The ID and description of the activites performed by the subjects (WALKING, STANDING...)
* features.txt: The names of the features related to the measurements taken by the sensors.
* subject_test.txt: The IDs of the subject for each observation of the test set.
* subject_train.txt: The IDs of the subject for each observation of the training set.
* X_test.txt: The measurements (features) of the test set.
* X_train.txt: The measurements (features) of the training set.
* y_test.txt: The IDs of the activities for each observation of the test set.
* y_train.txt: The IDs of the activities for each observation of the training set.

A full description of these files can be obtained in the README.txt in the zip file containing the data. 

### Main script 

The run_Analysis.r script located in the working directory processes the data files and generates a file
containing a tidy data set with the averages of the mean and standard deviation features for each subject
and each activity type. The steps of this data analysis are described in the CodeBook.md file.

In order to run the script that performs the data processing, make sure you already have the data files in
the data directory. Then you can go to the working directory and execute the following command:

source("run_Analysys.R")

### Output file

After executing the script, a file named tidy_data_averages.txt will be generated in the data directory, containing
the averages of the mean and standard deviation features for each subject and each activity type.

### Codebook

The code book with the details of the data transformations performed is available in the file CodeBook.md.