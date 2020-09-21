## This script downloads the "Human Activity Recognition Using Smartphones" 
## dataset by UCI, and unzip it.
## To avoid creating a messy working directory, the data has its own directory
## called "data"

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_directory <- "data"
file_local_path <- file.path(data_directory, "HumanActivityDataset.zip")

# Creates the data folder if it does not exist
if (!dir.exists(data_directory)){
    dir.create(data_directory)
}

# Download and unzip file
download.file(file_url, file_local_path)
unzip(zipfile = file_local_path, exdir = data_directory)
