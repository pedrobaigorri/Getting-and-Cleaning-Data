
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

I performed this operation for the datasets and also to the labels.

In addition I added to both datasets two columns of index, to ensure that the position of the rows can be stored during the rest of transformation processes. The creation of this indexes columns was done with the following code:

``
label_train_test$index <- seq(1:nrow(label_train_test))

``


