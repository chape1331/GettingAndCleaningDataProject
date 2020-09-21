## This script prepares a tidy dataset from the "Human Activity Recognition
## Using Smartphones" dataset by UCI.

##
## 1. Merges the training and the test sets to create one data set.
##

## Base folder containing the data files
base_input_folder <- file.path("data", "UCI HAR Dataset")
base_output_folder <- file.path("data")

## File paths for the train and test data, for each there are three files, one
## for the subject ids, one for the variables, and one for the activity labels.
train_subject_path <- file.path(base_input_folder, "train", "subject_train.txt")
train_observation_path <- file.path(base_input_folder, "train", "X_train.txt")
train_label_path <- file.path(base_input_folder, "train", "y_train.txt")

test_subject_path <- file.path(base_input_folder, "test", "subject_test.txt")
test_observation_path <- file.path(base_input_folder, "test", "X_test.txt")
test_label_path <- file.path(base_input_folder, "test", "y_test.txt")

# Load the data to data frames
train_subject_data <- read.csv(train_subject_path, header = FALSE)
train_observation_data <- read.csv(train_observation_path, header = FALSE, sep = "")
train_label_data <- read.csv(train_label_path, header = FALSE)

test_subject_data <- read.csv(test_subject_path, header = FALSE)
test_observation_data <- read.csv(test_observation_path, header = FALSE, sep = "")
test_label_data <- read.csv(test_label_path, header = FALSE)

# Integrate data frames for train and test data, and merge both together
train_dataset <- cbind(train_subject_data, train_observation_data, train_label_data)
test_dataset <- cbind(test_subject_data, test_observation_data, test_label_data)
dataset_1 <- rbind(train_dataset, test_dataset)

##
## 2. Extracts only the measurements on the mean and standard deviation for each 
## measurement.
##

# Load column names
column_names_path <- file.path(base_input_folder, "features.txt")
column_names <- read.csv(column_names_path, header = FALSE, sep = "\n")
# Include columns for subject (at the beginning) and activity (at the end)
column_names <- c("subject", column_names[,1], "activity")

# set column names
names(dataset_1) <- column_names

# Select columns that contain mean and standard deviation
selected_columns <- column_names[grep("^subject$|mean|std|^activity$", column_names)]
dataset_2 <- dataset_1[,selected_columns]



##
## 3. Uses descriptive activity names to name the activities in the data set
##

# Load activity names
activity_names_path <- file.path(base_input_folder, "activity_labels.txt")
activity_names_data <- read.csv(activity_names_path, header = FALSE, sep = "")

# Substitute numeric values with activity names
dataset_2$activity <- activity_names_data[dataset_2$activity, 2]


##
## 4. Appropriately labels the data set with descriptive variable names.
## 

# Remove leading numbers, spaces, and parentheses from function names,  
# e.g., "1 tBodyAcc-mean()-X" becomes "tBodyAcc-mean-X"
clean_column_names <- gsub("[()0-9 ]+", "", selected_columns)
names(dataset_2) <- clean_column_names

# Save tidy dataset to csv file
output_path <- file.path(base_output_folder, "HumanActivity_1_tidy.csv")
write.csv(dataset_2, output_path)

##
## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
##

library(dplyr)
library(tidyr)

## steps performed to calculate the average per variable, activity, and subject
## 1. convert columns into key (variable name), value (variable value) pair, 
## using gather
## 2. group the data by variable, activity, and subject
## 3. summarize the data using average on the value column
dataset_3 = dataset_2 %>%
            gather("variable", "value", -c("subject", "activity")) %>%
            group_by(variable, activity, subject) %>%
            summarize(average = mean(value))

# Save tidy dataset to csv file
output_path <- file.path(base_output_folder, "HumanActivity_2_tidy.csv")
write.csv(dataset_3, output_path)

