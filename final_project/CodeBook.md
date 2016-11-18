
# CodeBook for the tidy_dataset

This is the codebook of the final dataset created for the final assigment of the Getting-and-Cleaning data course.

## Introduction

The origin data is the result of the project performed by the UCI for monitoring the Human Activity through the use of Smartphones. Complete information about the project can be obtained in their website: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Origin dataset

The origin dataset contained the following information:

- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

## Transformations performed

Following the requirements of the final assignment the transformations performed on the dataset have been the following:

### Step 1 - Merges the training and the test sets to create one data set.

After loading the files into R, I used the functions rbind to join the datasets of train and tests.

I performed this operation for the datasets the labels and also the subjects data.

The result was the creation of three datasets with the following dimensions:

```
    train_test <- rbind(train, test)
    dim(train_test) # 10299 x 561
    dim(test)[1] + dim(train)[1] # 10299
    
    label_train_test <- rbind(labelTrain, labelTest)
    dim(label_train_test) # 10299 x 1

    subject_train_test <- rbind(subjectTrain, subjectTest)
    dim(subject_train_test) # 10299 x 1
```

In addition I added to all datasets two columns of index, to ensure that the position of the rows can be stored during the rest of transformation processes. The creation of this indexes columns was done with the following code:

```
  train_test$index <- seq(1:nrow(train_test))
  label_train_test$index <- seq(1:nrow(label_train_test))
  subject_train_test$index <- seq(1:nrow(subject_train_test))
```
### Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement

I read the name of the variables from the features.txt file. Then selected the only the variables that has the word "mean" followed of '(' or the "std" in the name of the variable. And then subset the dataset according to this. 

The code that performs this part is the following:

```
    #loading the features dataset with the name of the variables
    featuresFile <- "./data/UCI HAR Dataset/features.txt"
    features <- read.table(featuresFile)
    head(features)
    dim(features) # 561 x 2
   
    # getting the variables of interest
    mean_std_variables <- grepl("mean[(]|std()", features[,2])
    mean_std_variables[562] <- TRUE #index variable
    table(mean_std_variables)
    
    # subsetting the dataset with the desired variables
    train_test <- train_test[, mean_std_variables]
    dim(train_test) #10299 x 67
    
    #subsetting features dataset with the names required for step 4
    features <- features[mean_std_variables[1:nrow(features)], 2]
```
### Step 3 - Uses descriptive activity names to name the activities in the data set

After loading the activity names from activity_file.txt, I added the activity name to the label_train_test dataset using the the function merge where the key varible to perform the merge is the V1.

Then I used again the function merge to join this the labels to the core dataset by using as key the index variable to ensure that I mantain the order of the rows properly. I do the same with the subjects_dataset.

The code that performs this operation is the following:

```
    # loading activity file    
    activityFile <- "./data/UCI HAR Dataset/activity_labels.txt"
    labels <- read.table(activityFile)
    head(labels)
    dim(labels) # 6 x 2
    
    # merging with label dataset
    label_train_test <- merge(label_train_test, labels)
    
    #removing column V1
    label_train_test <- select(label_train_test, -V1)
    
    # setting colname
    colnames(label_train_test)[2] <- "activity"
    
    # merging to train_test dataset
    train_test <- merge(train_test, label_train_test, by.x = "index", by.y = "index")
    head(train_test)
    dim(train_test) # 10299 x 68
    
    # merging also subjects dataset
    colnames(subject_train_test)[1] <- "subject"
    train_test <- merge(train_test, subject_train_test, by.x = "index", by.y = "index")
    head(train_test)
    dim(train_test) # 10299 x 69
```
### Step 4 - Appropriately labels the data set with descriptive variable names

First modified a little bit the names of the variables to make them more understandables, and then assign this names to the colnames of the dataset.

```
    #subject and labels variable names already set
    #only measurement labels are missing loaded in features
    
    # adapting the names of the variables to make them more clear
    features <- sub("\\()", "", features)
    features <- sub("^f", "frequency", features)
    features <- sub("^t", "time", features)
    features <- sub("Acc", "Accelerometer", features)
    features <- sub("Gyro", "Gyroscope", features)
    features <- sub("Mag", "Magnitude", features)
    
    # dropping the index column as now is not required
    train_test <- select(train_test, -index)
    dim(train_test) # 10299 x 68
    
    
    # setting the colnames of the dataset
    colnames(train_test)[1:66] <- features
```

### Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

I use the function agreggate to calculate the avg of each of the columns per each activity and subject. The code that performs this operation is:

```
    agg_train_test <- aggregate(train_test, list(train_test$subject, train_test$activity), FUN= mean)
    
    # remove the replicated variables subject & list
    agg_train_test <- select(agg_train_test, -activity)
    agg_train_test <- select(agg_train_test, -subject)
    
    #rename grouping variables to subject & activity
    colnames(agg_train_test)[1] <- "subject"
    colnames(agg_train_test)[2] <- "activity"

    head(agg_train_test)
    dim(agg_train_test) # 180 x 68
```

Finally I wrote the dataset to the final file:

``` 
write.table(agg_train_test, "tidy_dataset.txt", row.names = F)
```



