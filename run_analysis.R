## Prepare directory and download the files

flink <- getwd()
projectdirectory <- paste0(flink, "/week4project/")
if(!dir.exists(projectdirectory)) {
        dir.create(projectdirectory)
}

furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fname <- paste0(projectdirectory, "projdataset.zip")
if(!file.exists(fname)) {
        download.file(furl, destfile = fname)
}
ucihar <- paste0(projectdirectory, "UCI HAR Dataset")


### Step 1: Merges the training and the test sets to create one data set.

## Import every text file to R
# Import the activity_labels and features text files from the root directory
activity <- read_table(paste0(ucihar, "/activity_labels.txt"), col_names = c("a", "activity"))
features <- read_table2(paste0(ucihar, "/features.txt"), col_names = c("a", "features"))

# Import the files from the test folder
testx <- read_table2(paste0(ucihar, "/test/X_test.txt"), col_names = FALSE)
testy <- read_table2(paste0(ucihar, "/test/y_test.txt"), col_names = "actnum")
testsubject <- read_table2(paste0(ucihar, "/test/subject_test.txt"), col_names = c("subject"))

# Import the files from the train folder
trainx <- read_table2(paste0(ucihar, "/train/X_train.txt"), col_names = FALSE)
trainy <- read_table2(paste0(ucihar, "/train/y_train.txt"), col_names = "actnum")
trainsubject <- read_table2(paste0(ucihar, "/train/subject_train.txt"), col_names = c("subject"))

## Merge the files together
# Use rbind to merge the files from the train and test datasets
x <- rbind(trainx, testx)
y <- rbind(trainy, testy)
subject <- rbind(trainsubject, testsubject)

# Save the feature names to be the column name of the x data set
features2 <- unlist(features[2])
names(x) <- features2

# Merge the 3 datasets
mydataset <- cbind(subject, y, x)

### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

## Extract the mean and sd of each measurement
# Use the grep function to found out the indices of the measurements
# with mean and std in their names
withmean <- grep("mean", names(mydataset))
withstd <- grep("std", names(mydataset))

# Subset mydataset
mydataset2 <- mydataset[, c(1, 2, withmean, withstd)]


### Step 3: Uses descriptive activity names to name the activities in the data set

## Merge the mydataset2 and the activity datasets
tidy_ds <- merge(mydataset2, activity, by.x = "actnum", by.y = "a")

# Rearrange tidy_ds so that the activity column is on the second column after the subject column
tidy_ds2 <- select(tidy_ds, subject, activity, everything())


### Step 4: Appropriately labels the data set with descriptive variable names.

## Rename labels the dataset variable names
# Load stringr package
library(stringr)

# Make all characters to lower caps and rename the labels
names(tidy_ds2) <- names(tidy_ds2) %>% 
                        str_to_lower() %>%
                        str_replace_all("acc", "accel") %>%
                        str_replace_all("^t", "time") %>%
                        str_replace_all("^f", "freq") %>%
                        str_replace_all("mean()", "mean") %>%
                        str_replace_all("mag", "magnitude") %>%
                        str_replace_all("std()", "std")
                        
# Remove actnum column
tidy_ds3 <- tidy_ds2[, c(1:2, 4:82)]


### Step 5: From the data set in step 4, creates a second, independent tidy data 
### set with the average of each variable for each activity and each subject.
library(dplyr)
final_ds <- tidy_ds3 %>%
                        group_by(subject, activity) %>%
                        summarize_all(mean)
write.table(final_ds, "FinalDataset.txt", row.names = FALSE)
