# Code Book
2016-03-14 23:25:40 for Coursera Getting & Cleaning Data Assignment

## Data analysis, transformations and variables:
* Download dataset: `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
* Decompress dataset: `getdata-projectfiles-UCI HAR Dataset.zip` in `UCI HAR Dataset`
* Load the activity labels dataset: `UCI HAR Dataset/activity_labels.txt`
	+ `loadedActivityLabels` is the data table in which the activity labels are stored. It has 2 variables.
		+ `activity_id` (integer) -- a numeric ID for each activity
		+ `activity` (factor) -- a string describing each activity
* Load the features dataset: `UCI HAR Dataset/features.txt`
	+ `loadedFeatures` is the data table in which the features are stored. It has 2 variables.
		+ `feature_id` (integer) -- a numeric ID for each feature
		+ `feature` (factor) -- a string describing each feature, thoroughly described in features_info.txt.
* Load the `test` dataset.
	+ Load the subjects' data from: `UCI HAR Dataset/test/subject_test.txt`
	+ Load the measurements' data from: `UCI HAR Dataset/test/X_test.txt`
	+ Substitute the variable names of the measurements with the activity labels.
	+ Keep only the mean and standard deviation measurements of the dataset.
	+ Load the activities' data from: `UCI HAR Dataset/test/y_test.txt`
	+ Join the activity dataset with the activity labels, so that activities have descriptive names.
	+ Merge subject, activity and measurement datasets into a one tidy `test` dataset.
* Load the `train` dataset.
	+ Load the subjects' data from: `UCI HAR Dataset/train/subject_train.txt`
	+ Load the measurements' data from: `UCI HAR Dataset/train/X_train.txt`
	+ Substitute the variable names of the measurements with the activity labels.
	+ Keep only the mean and standard deviation measurements of the dataset.
	+ Load the activities' data from: `UCI HAR Dataset/train/y_train.txt`
	+ Join the activity dataset with the activity labels, so that activities have descriptive names.
	+ Merge subject, activity and measurement datasets into a one tidy `train` dataset.
* Merge the `test` and `train` tidy datasets into `mergedset`.
* Construct a (new) tidy dataset (`meanMerged`) with the average of each measurement for each activity and each subject using `mergedset`.
* Properly annotate the columns of `meanMerged` with the respective appropriate variable names.
	+ Set the name of the first column to `activity`, which groups data for each activity.
	+ Set the name of the second column to `subjectId`, which groups data for each subject.
* Write the tidy `meanMerged` dataset to the file: `meanMerged.txt` which named rows.

## Notes on calculated values in the `meanMerged` dataset: 
* The first variable `activity` (factor), which groups data for each activity has 6 levels representing the possible activities untaken by the subjects.
* The second variable `subjectId` (integer), which groups data for each subject is the ID of the respective subject and takes values in the range [1,30].
* The remaining variables in the dataset are the features (see individual descriptions in `features_info.txt`) average values for each activity and subject:

| Feature        |        type     |   min average   |   max average   |
| -------------- |:---------------:|:---------------:|:---------------:|
| tBodyAcc-mean()-X|numeric|0.2215982|0.301461|
| tBodyAcc-mean()-Y|numeric|-0.04051395|-0.001308288|
| tBodyAcc-mean()-Z|numeric|-0.1525139|-0.07537847|
| tBodyAcc-std()-X|numeric|-0.9960686|0.6269171|
| tBodyAcc-std()-Y|numeric|-0.9902409|0.616937|
| tBodyAcc-std()-Z|numeric|-0.9876587|0.6090179|
| tGravityAcc-mean()-X|numeric|-0.6800432|0.9745087|
| tGravityAcc-mean()-Y|numeric|-0.4798948|0.9565938|
| tGravityAcc-mean()-Z|numeric|-0.4950887|0.957873|
| tGravityAcc-std()-X|numeric|-0.9967642|-0.8295549|
| tGravityAcc-std()-Y|numeric|-0.9942476|-0.6435784|
| tGravityAcc-std()-Z|numeric|-0.9909572|-0.6101612|
| tBodyAccJerk-mean()-X|numeric|0.0426881|0.130193|
| tBodyAccJerk-mean()-Y|numeric|-0.03868721|0.05681859|
| tBodyAccJerk-mean()-Z|numeric|-0.06745839|0.03805336|
| tBodyAccJerk-std()-X|numeric|-0.9946045|0.544273|
| tBodyAccJerk-std()-Y|numeric|-0.9895136|0.3553067|
| tBodyAccJerk-std()-Z|numeric|-0.9932883|0.03101571|
| tBodyGyro-mean()-X|numeric|-0.2057754|0.1927045|
| tBodyGyro-mean()-Y|numeric|-0.2042054|0.02747076|
| tBodyGyro-mean()-Z|numeric|-0.0724546|0.1791021|
| tBodyGyro-std()-X|numeric|-0.9942766|0.2676572|
| tBodyGyro-std()-Y|numeric|-0.9942105|0.4765187|
| tBodyGyro-std()-Z|numeric|-0.9855384|0.5648758|
| tBodyGyroJerk-mean()-X|numeric|-0.1572125|-0.02209163|
| tBodyGyroJerk-mean()-Y|numeric|-0.07680899|-0.01320228|
| tBodyGyroJerk-mean()-Z|numeric|-0.09249985|-0.006940664|
| tBodyGyroJerk-std()-X|numeric|-0.9965425|0.1791486|
| tBodyGyroJerk-std()-Y|numeric|-0.9970816|0.2959459|
| tBodyGyroJerk-std()-Z|numeric|-0.9953808|0.1932065|
| tBodyAccMag-mean()|numeric|-0.9864932|0.6446043|
| tBodyAccMag-std()|numeric|-0.9864645|0.4284059|
| tGravityAccMag-mean()|numeric|-0.9864932|0.6446043|
| tGravityAccMag-std()|numeric|-0.9864645|0.4284059|
| tBodyAccJerkMag-mean()|numeric|-0.9928147|0.4344904|
| tBodyAccJerkMag-std()|numeric|-0.9946469|0.4506121|
| tBodyGyroMag-mean()|numeric|-0.9807408|0.4180046|
| tBodyGyroMag-std()|numeric|-0.9813727|0.299976|
| tBodyGyroJerkMag-mean()|numeric|-0.9973225|0.08758166|
| tBodyGyroJerkMag-std()|numeric|-0.9976661|0.2501732|
| fBodyAcc-mean()-X|numeric|-0.9952499|0.537012|
| fBodyAcc-mean()-Y|numeric|-0.9890343|0.5241877|
| fBodyAcc-mean()-Z|numeric|-0.9894739|0.280736|
| fBodyAcc-std()-X|numeric|-0.9966046|0.6585065|
| fBodyAcc-std()-Y|numeric|-0.9906804|0.5601913|
| fBodyAcc-std()-Z|numeric|-0.9872248|0.6871242|
| fBodyAccJerk-mean()-X|numeric|-0.9946308|0.4743173|
| fBodyAccJerk-mean()-Y|numeric|-0.9893988|0.2767169|
| fBodyAccJerk-mean()-Z|numeric|-0.9920184|0.1577757|
| fBodyAccJerk-std()-X|numeric|-0.9950738|0.4768039|
| fBodyAccJerk-std()-Y|numeric|-0.9904681|0.3497713|
| fBodyAccJerk-std()-Z|numeric|-0.9931078|-0.006236475|
| fBodyGyro-mean()-X|numeric|-0.9931226|0.4749624|
| fBodyGyro-mean()-Y|numeric|-0.9940255|0.328817|
| fBodyGyro-mean()-Z|numeric|-0.9859578|0.4924144|
| fBodyGyro-std()-X|numeric|-0.9946522|0.1966133|
| fBodyGyro-std()-Y|numeric|-0.9943531|0.6462336|
| fBodyGyro-std()-Z|numeric|-0.9867253|0.5224542|
| fBodyAccMag-mean()|numeric|-0.9868006|0.5866376|
| fBodyAccMag-std()|numeric|-0.9876485|0.1786846|
| fBodyBodyAccJerkMag-mean()|numeric|-0.9939983|0.5384048|
| fBodyBodyAccJerkMag-std()|numeric|-0.9943667|0.3163464|
| fBodyBodyGyroMag-mean()|numeric|-0.9865352|0.2039798|
| fBodyBodyGyroMag-std()|numeric|-0.9814688|0.2366597|
| fBodyBodyGyroJerkMag-mean()|numeric|-0.9976174|0.1466186|
| fBodyBodyGyroJerkMag-std()|numeric|-0.9975852|0.2878346|
