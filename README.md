Getting and Cleaning Data
CourseProject
===================================

This repository contains the script for the course project.  It also contains a README file and a CodeBook for understanding the steps taken in producing the data results.

The source data can be download in a zip file from the following location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This data should be extracted without modifications to the directory structure and placed into your working directory for R.  If the directory structure from the data is modified, the script will not be able to read in the data.

After the data is downloaded, you can execute the R script run_analysis.R on the data set.

The script expects to find a subdirectory of UCI HAR Dataset containing the data files.

The output of run_analysis.R is a CSV file named tidydata.csv which contains the final data result set.  It also displays the results to the console.
