
## CodeBook for run_analysis.R

The `run_analysis.R` script prepares the dataset to be ready for analysis.

The following are the steps done and their variables:

#### **STEP 1:** Merges the training and the test sets to create one dataset.

a. Download the dataset
	1. `flink`, the current RStudio working directory
	2. `projectdirectory`, the folder where the dataset will be downloaded
	3. `furl`, the file url
	4. `fname`, the file name
	5. `ucihar`, the directory of the unzipped dataset
		
b. Importing the data sets
	1. `activity`, contains the imported data from the *activity.txt* file
	2. `features`, contains the imported data from the *features.txt* file
	3. `testx`, contains the imported data from the *X_test.txt* file inside the **test** folder
	4. `testy`, contains the imported data from the *y_test.txt* file inside the **test** folder
	5. `testsubject`, contains the imported data from the *subject_test.txt* file inside the **test** folder
	6. `trainx`, contains the imported data from the *X_train.txt* file inside the **train** folder
	7. `trainy`, contains the imported data from the *y_train.txt* file inside the **train** folder
	8. `trainsubject`, contains the imported data from the *subject_train.txt* file inside the **train** folder
		
c. Merging the datasets
	1. `x`, merged dataset from `trainx` and `testx`
	2. `y`, merged dataset from `trainy` and `testx`
	3. `subject`, merged dataset from `trainsubject` and `testsubject`
	4. `features2`, a converted character vector from the variable, `features`
	5. `mydataset`, the combined dataset after merging the `x`, `y`, and `subject` datasets
		
		
#### **STEP 2:** Extracts only the measurements on the mean and standard deviation for each measurement.

a. Use the grep function to found out the indices of the measurements with mean and std in their names
	1. `withmean`, numeric vector containing the indices of those with "mean" in the column names of `mydataset`
	2. `withstd`, numeric vector containing the indices of those with "std" in the column names of `mydataset`
	
b. Subset `mydataset` to get extract the columns
	1. `mydataset2`, a subset of `mydataset` containing only the mean and std columns
	
		
#### **STEP 3:** Uses descriptive activity names to name the activities in the dataset
a. Merging `mydataset2` with activity dataset
	1. `tidy_ds`, the resulting dataset after replacing the numerical equivalent of the `activity` names with descriptions
	2. `tidy_ds2, the dataset after re-arranging the columns by putting the `activity` names at the second column

		
#### **STEP 4:** Appropriately labels the data set with descriptive variable names.
a. Make all characters to lower caps and rename the labels
	1. All labels were renamed to lower caps
	2. Replace *acc* with *accel*
	3. Replace *^t* with *time*
	4. Replace *^f* with *freq*
	5. Replace *mean()* with *mean*
	6. Replace *mag* with *magnitude*
	7. Replace *std()* with *std*


#### **StEP 5:** From the data set in step 4, creates a second, independent tidy data 
a. `final_ds`, dataset where the mean of each measurement was taken for each activity and each subject.
b. Create a file named *"FinalDataset.txt"* for submission to the course
