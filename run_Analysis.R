#download and extract zip file to current directory
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Data.zip")
unzip(paste(getwd(),"/Data.zip",sep=''))
# get feature and activity labels
allfeatures=read.table("UCI HAR Dataset/features.txt")
actCorr=read.table("UCI HAR Dataset/activity_labels.txt")
# get data
#get subject ID
subject_train=read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test=read.table("UCI HAR Dataset/test/subject_test.txt")
#get train/test data
X_train=read.table("UCI HAR Dataset/train/X_train.txt")
y_train=read.table("UCI HAR Dataset/train/y_train.txt")
X_test=read.table("UCI HAR Dataset/test/X_test.txt")
y_test=read.table("UCI HAR Dataset/test/y_test.txt")
#column-bind id_train:X_train:y_train
train_bind=cbind(cbind(subject_train,X_train),y_train)
#column-bind id_test:X_test:y_test
test_bind=cbind(cbind(subject_test,X_test),y_test)
#row-bind train and test
Xy_all = rbind(train_bind,test_bind)
# create dataframe with column labels: one data set
dataset=data.frame(Xy_all)
colnames(dataset)=c("id",allfeatures[,2],"activity")
# select tri-axial accelerometer (body and gravity) and gyroscope (body only) "mean" and "std" variables only
dataset=dataset[,c(1,grep("^tBodyAcc-mean|^tGravityAcc-mean|^tBodyAcc-std|^tGravityAcc-std|^tBodyGyro-mean|^tBodyGyro-std",colnames(dataset)),length(dataset[1,]))]
dataset[,length(dataset)]=factor(dataset[,length(dataset)],labels=actCorr[,2])
library(reshape)
mdataset <- melt(dataset, id=c("id","activity"))
tidyset <- cast(mdataset, variable~activity~id, mean)