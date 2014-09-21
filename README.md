# Getting and Cleaning Data Course Project

### Prepare data for analysis

First of all I load the required packages - "data.table", "reshape2". After reading the data I use "cbind" function to merge the 3 data files into 1 data frame for test and training data as well. At this point we have 2 data frames which need to be merged with "rbind" function.

```r
#load packages
library(data.table)
library(reshape2)

#read test data
y_test <- read.table("./test/y_test.txt")
x_test <- read.table("./test/X_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#read training data
y_train <- read.table("./train/y_train.txt")
x_train <- read.table("./train/X_train.txt")
subject_train <- read.table("./train/subject_train.txt")

#merge data
tdtest <- cbind(subject_test, y_test, x_test)
tdtrain <- cbind(subject_train, y_train, x_train)
td <- rbind(tdtest, tdtrain)
```

### Add descriptive variable names to the data set

I read the variable names from "features.txt" and assign them to the appropriate columns using "colnames" function.

```r
#add variable names
colnames(td)[1:2] <- c("Subject", "Activity")
features <- read.table("./features.txt")
vnames <- as.character(features$V2)
colnames(td)[3:563] <- vnames
```

### Extract only the measurements on the mean and standard deviation for each measurement

I simply select the columns containing the subject, activity, standard deviation and mean values.

```r
#extract the mean and standard deviation variables
td <- td[,c(1:2,203:204,216:217,229:230,242:243,255:256,505:506,518:519,531:532,544:545)]
```

### Appropriately labels the data set with descriptive variable names

I read the "activity_labels.txt" to get descriptive values instead of numbers. After that I owewrite the numbers with descriptive values, such as "STANDING". For this I use the below commands:

```r
actlab <- read.table("./activity_labels.txt")
td[, 2] <- actlab[td[, 2], 2]
```

### Create a second, independent tidy data set

This data set contains the average of each variable for each activity and each subject using the "melt" and "dcast" functions. Finally I create a data file for this second tidy data set using the "write" function.

```r
#create the second tidy data set
tdm <- melt(td,id=c("Subject","Activity"),measure.vars=names(td)[3:20])
td2 <- dcast(tdm, Subject + Activity ~variable,mean)
write.table(td2,file="td2.txt")
```