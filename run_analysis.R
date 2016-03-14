# 
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
# 
#######################################################################################################################

# Auxiliary stuff for generating the CodeBook file
codebookFile <- "CodeBook.md"

if (file.exists(codebookFile)) {
  unlink(codebookFile, force=TRUE)
}

codebook <- function(...) {
  cat(..., "\n",file=codebookFile,append=TRUE, sep="")
  cat("[==] ", ..., "\n", sep="")
}

codebook("# Code Book")
codebook(as.character(Sys.time())," for Coursera Getting & Cleaning Data Assignment")
codebook("")  
codebook("## Data analysis, transformations and variables:")

#######################################################################################################################
library(dplyr)

furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fname <- "getdata-projectfiles-UCI HAR Dataset.zip"
datadir <- "UCI HAR Dataset"

## Download dataset:
codebook("* Download dataset: `",furl,"`")
if (!file.exists(fname)) {
  fileURL <- furl
  download.file(fileURL, fname, method="curl")
}  

codebook("* Decompress dataset: `",fname,"` in `",datadir,"`")
if ( !file.exists(datadir) ) # just checking the data directory is there
{
  unzip(fname)
  
  # if we failed decompressing abort
  if ( !file.exists(datadir) )
  {
    stop("The \"UCI HAR Dataset\" directory cannot be found.")
  }
}

# we are most likely good to go!
#######################################################################################################################

activityLabelsFile <- paste0(datadir,"/activity_labels.txt")
loadedActivityLabels <- read.table(activityLabelsFile, col.names = c("activity_id","activity"))
codebook("* Load the activity labels dataset: `", activityLabelsFile, "`")
codebook("\t+ `loadedActivityLabels` is the data table in which the activity labels are stored. It has ", length(names(loadedActivityLabels)), " variables.")
codebook("\t\t+ `activity_id` (integer) -- a numeric ID for each activity")
codebook("\t\t+ `activity` (factor) -- a string describing each activity")

# load the features list dataset (we do this once)
featuresFile <- paste0(datadir,"/features.txt")
loadedFeatures <- read.table(featuresFile, col.names = c("feature_id","feature"))
codebook("* Load the features dataset: `", featuresFile, "`")
codebook("\t+ `loadedFeatures` is the data table in which the features are stored. It has ", length(names(loadedFeatures)), " variables.")
codebook("\t\t+ `feature_id` (integer) -- a numeric ID for each feature")
codebook("\t\t+ `feature` (factor) -- a string describing each feature, thoroughly described in features_info.txt.")


# simple function to load datasets when called
loadDataSet <- function(dsetName)
{
  codebook("* Load the `", dsetName, "` dataset.")
  
  subjectFile <- paste0(datadir, "/", dsetName, "/", "subject_", dsetName, ".txt")
  if ( file.exists(subjectFile) )
  {
    codebook("\t+ Load the subjects' data from: `", subjectFile, "`")
    subjectDataset <- read.table(subjectFile, stringsAsFactors=FALSE, col.names = c("subjectId"))
    #print(str(subjectDataset))
  }
  
  
  xFile <- paste0(datadir, "/", dsetName, "/", "X_", dsetName, ".txt")
  if ( file.exists(xFile) )
  {
    codebook("\t+ Load the measurements' data from: `", xFile, "`")
    xDataset <- read.table(xFile, stringsAsFactors=FALSE)
    
    codebook("\t+ Substitute the variable names of the measurements with the activity labels.")
    names(xDataset) <- loadedFeatures[,2]
    
    codebook("\t+ Keep only the mean and standard deviation measurements of the dataset.")
    xDataset <- xDataset[,grep("(mean|std)\\(\\)", loadedFeatures[,2], value = FALSE)]

    #print(str(xDataset))
  }
  
  
  yFile <- paste0(datadir, "/", dsetName, "/", "y_", dsetName, ".txt")
  if ( file.exists(yFile) )
  {
    codebook("\t+ Load the activities' data from: `", yFile, "`")
    yDataset <- read.table(yFile, stringsAsFactors=FALSE, col.names = c("activity_id"))
    
    codebook("\t+ Join the activity dataset with the activity labels, so that activities have descriptive names.")
    yDataset <- yDataset %>% left_join(loadedActivityLabels, by = "activity_id")
    
    #print(str(yDataset))
  }
  
  codebook("\t+ Merge subject, activity and measurement datasets into a one tidy `", dsetName, "` dataset.")
  dset <- cbind(subjectDataset, activity=yDataset$activity, xDataset)
  
  dset
}

#######################################################################################################################

# load the two datasets sequencially
testset <- loadDataSet("test")
trainset <- loadDataSet("train")

codebook("* Merge the `test` and `train` tidy datasets into `mergedset`.")
mergedset <- rbind(testset, trainset)

codebook("* Construct a (new) tidy dataset (`meanMerged`) with the average of each measurement for each activity and each subject using `mergedset`.")
meanMerged <- aggregate(mergedset[, 3:length(names(mergedset))], list(mergedset$activity, mergedset$subjectId), mean)

codebook("* Properly annotate the columns of `meanMerged` with the respective appropriate variable names.")
codebook("\t+ Set the name of the first column to `activity`, which groups data for each activity.")
codebook("\t+ Set the name of the second column to `subjectId`, which groups data for each subject.")
names(meanMerged)[1] <- "activity"
names(meanMerged)[2] <- "subjectId"

codebook("* Write the tidy `meanMerged` dataset to the file: `meanMerged.txt` which named rows.")
write.table(meanMerged,"meanMerged.txt", row.name=FALSE)

codebook("") 
codebook("## Notes on calculated values in the `meanMerged` dataset: ")
codebook("* The first variable `activity` (factor), which groups data for each activity has 6 levels representing the possible activities untaken by the subjects.")
codebook("* The second variable `subjectId` (integer), which groups data for each subject is the ID of the respective subject and takes values in the range [1,30].")
codebook("* The remaining variables in the dataset are the features (see individual descriptions in `features_info.txt`) average values for each activity and subject:")
codebook("") 
codebook("| Feature        |        type     |   min average   |   max average   |")
codebook("| -------------- |:---------------:|:---------------:|:---------------:|")
invisible(lapply(names(meanMerged)[3:length(names(meanMerged))], 
          function(x) codebook("| ", x[1], "|", class(meanMerged[x[1]][1,]), "|", min(meanMerged[x[1]]), "|", max(meanMerged[x[1]]),"|")))





