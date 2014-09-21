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

#add variable names
colnames(td)[1:2] <- c("Subject", "Activity")
features <- read.table("./features.txt")
vnames <- as.character(features$V2)
colnames(td)[3:563] <- vnames

#extract the mean and standard deviation variables
td <- td[,c(1:2,203:204,216:217,229:230,242:243,255:256,505:506,518:519,531:532,544:545)]

#use activity names in the data
actlab <- read.table("./activity_labels.txt")
td[, 2] <- actlab[td[, 2], 2]

#create the second tidy data set
tdm <- melt(td,id=c("Subject","Activity"),measure.vars=names(td)[3:20])
td2 <- dcast(tdm, Subject + Activity ~variable,mean)
write.table(td2,file="td2.txt")