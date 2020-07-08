library(plyr)
library(dplyr)
library(data.table)
library(tidyr)

localpath <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/"
#localpath <- "E:/RLang/datasciencecoursera/UCI HAR Dataset/"

test <- read.table(paste0(localpath, "test/X_test.txt"))
train <- read.table(paste0(localpath, "train/X_train.txt"))
trainactivity <- read.table(paste0(localpath, "train/Y_train.txt"))
testactivity <- read.table(paste0(localpath, "test/Y_test.txt"))
subjectidtest <- read.table(paste0(localpath, "test/subject_test.txt"))
subjectidtrain <- read.table(paste0(localpath, "train/subject_train.txt"))

trainactivity <- setnames(trainactivity, c('Activity'))
testactivity <- setnames(testactivity, c('Activity'))
subjectidtest <- setnames(subjectidtest, c('Subject'))
subjectidtrain <- setnames(subjectidtrain, c('Subject'))

features <- read.table(paste0(localpath, "features.txt"))
activities <- read.table(paste0(localpath, "activity_labels.txt"))

## bind subject and activity columns to the first columns of the data sets
test <- cbind(subjectidtest, testactivity, test)
train <- cbind(subjectidtrain, trainactivity, train)

## append train and test rows
finalset <- rbind(train, test)

## make list of column names
q <- c('Subject', 'Activity', lapply(features$V2, as.character))
q <- gsub('\\(\\)', '', q)
q <- gsub('Acc', 'Acceleration', q)
q <- gsub('Gyro', 'Gyroscope', q)


## create data frame using features as the column headers
finalset <- setNames(finalset, as.vector(unlist(q)))

#Create data set with each measurement on its own row, the measurement is the real variable
finalset <- pivot_longer(finalset, -c(Subject, Activity), names_to = "Measurement", values_to = "MeasurementValue")

#separate the measurement columns into their components of Type, Statistic, and Direction
finalset <- separate(finalset, Measurement, c("Type", "Statistic", "Direction"), "-", fill = "right")

#The direction has two items in it separated by a comma
finalset <- separate(finalset, Direction, c("CartesianDirection", "Coefficient"), ",", fill = "right")

#separate the type column into two, frequency/time and measurement 
finalset <- separate(finalset, Type, c("domain", "Measure"), 1, fill = "right")
domainType <- data.frame(code = c('f', 't'), Domain=c('Frequency', 'Time'))

#Merge the descriptive labels for the six activity types
#This should be the final tidy dataset for the full dataset
finalset <- finalset %>% merge(activities, by.x = 'Activity', by.y = 'V1', sort = FALSE) %>% 
  select(-Activity) %>%
  rename(c('Activity' = 'V2')) %>%
  group_by(Subject, Activity) %>%
  arrange(Subject, Activity) %>%
  merge(domainType, by.x = 'domain', by.y = 'code') %>%
  select(Subject, Activity, Measure, Statistic, CartesianDirection, Coefficient, Domain, MeasurementValue)

#To get smaller data set for the means of all of the measurements
#Remove Coefficient for set of means
#Get measurements of type mean or std
#Group to get final means
#Summarize data to get means by group into a tidy set
datasetForMeans <- finalset %>%
  select(-Coefficient) %>%
  filter(grepl("mean", Statistic) | grepl("std", Statistic)) %>% 
  group_by(Subject, Activity, Measure, Statistic, CartesianDirection, Domain) %>% 
  dplyr::summarize(MeasurementMean = mean(MeasurementValue))

write.csv(datasetForMeans, paste0(localpath, "tidyDataSet.csv"))

