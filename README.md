---
title: "ReadMe"
author: "Me"
date: "7/7/2020"
output: html_document
---

The following is extracted from the readme file for the UCI HAR Dataset:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>  

##### Human Activity Recognition Using Smartphones Dataset  
Version 1.0  

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.  
Smartlab - Non Linear Complex Systems Laboratory  
DITEN - Universit? degli Studi di Genova.  
Via Opera Pia 11A, I-16145, Genoa, Italy.  
activityrecognition@smartlab.ws  
www.smartlab.ws  

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

##### For each record it is provided:  
  

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Script File run_analysis.Rmd

The script run_analysis.Rmd reads the data files contained in the zip file referenced above and creates a tidy dataset from
the data in those files. The final output is a tidy dataset of the means of the measurements grouped by subject, activity, and measurement categories.  

The script assumes that the zip file referenced above has been downloaded to an accessible location and unzipped. There is a variable "localpath" that should be set to the location of the unzipped files. It is also dependent on the following packages: 

- plyr
- dplyr
- data.table
- tidyr  

The original dataset was broken into a lengthwise dataset based on the measurements in the columns of the union of the training and test datasets. Each column was a combination of 2 to 4 different components that should be separated to facilitate analysis. They are as follows:  

- Measurement domain as in time or frequency based measurements  
- Main object being measured e.g. - Acceleration and Gyroscopic measurements
- Statistic from the measurement e.g. - Mean or Standard Deviation
- Cartesian Direction e.g. X, Y, Z as in forward/backward, left/right, up/down
- Numeric factor for some measurements appended to the full name of the column (dropped from final dataset)  

The measurements were separated into different columns to facilitate analyzing data by the components of the measurement. For example, if someone wanted to analyze the time domain measurments in lateral directions, this separation makes it easier to accomplish than having to filter on parts of the column name.  

Once the data were put into this format, it was grouped by the subject, activity, domain, measured object, statistic, and Cartesian direction. Once the grouping was completed, the dataset was summarized to create the final tidy dataset saved in the tidyDataset.txt file.

