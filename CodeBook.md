Code Book
For Getting and Cleaning Data Course Project

The following packages are required for running the script:
plyr
sqldf

This script assumes that the data has been extracted into a directory names "UCI HAR Dataset" situated in the
working directory.  This would be the default directory name when the data is extracted from the zip file.

First file read in is the activity_labels.txt file and is read into the activity object.  After reading in, the 
columns are renamed for clarity.
This file contains the six activities and labels that will be used in relation to the subject data.

The features.txt file is read into the features object.  The values in the file are massaged to makes them character 
data and to remove special characters for ease in use of R functions later in the script.
This file contains the labels for the various measurements taken.  Removing the special characters and replacing them
with spaces is the extent to which I make them more readable.

There are three files containing the test subject data.  subject_test.txt, x_test.txt and y_test.txt are read in and then
"merged" using column binding to create the test_data object.

There are three files containing the training subject data.  subject_train.txt, x_train.txt and y_train.txt are read in and then "merged" using column binding to create the train_data object.

The test_data and train_data object are then "merged" using row binding into a combined measurement object all_data.

Next I modify all_data by merging the activity object with all_data.  Finally, I update the column names to
match the features labels.  I would call this data set tidy and complete and it is from this data set that I now work
from.

However, this data set includes more data than we need.  It is my understanding that we want to work with the data that contains results of mean and standard deviations.  I create a vector of columns needed by using the grep function to find column names that include "std" and "mean".  I then use the vector to extract a new data frame (tidy_data) that includes only  those columns.

Finally, using that tidy_data data frame, I apply a sqldf function to find the average of all of the standard deviation data and mean data, grouping the results by subject and activity.
