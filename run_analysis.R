# Clean data assignment
# =======================
#
# By: Jorge Sauma
# Date: 09/14/2017
#
# This script loads the training and testing data from the UCI Dataset
# and merge them together in a single file. Also, the subject and the
# Activity are added as the first variables in order to bind this info
# with the measurments.
# Once the data is merged, the average for the combination
# subject-activity-feature is calculated for each variable
# related with the mean or the std calculations. For example,
# tBodyAcc-mean()-X and tBodyAcc-std()-X. The resulting variables would
# be called Average_tBodyAcc-mean()-X and Average_tBodyAcc-std()-X and
# will be related to, let's say, subject 1, activity WALKING.
#
# To make the data set more clear, the column Activity has the name of
# the activity instead of the activity id.
# 
# The final dataset is stored in the AverageValue_Mean_STD.txt file
#
# The dataset complies with the tidy data rules described in 
# https://www.jstatsoft.org/article/view/v059i10/v59i10.pdf
#
# These rules are:
#    1. Each variable forms a column: average for one feature
#    2. Each observation forms a row: one subject doing one activity
#    3. Each type of observational unit forms a table: averages for the 
#             subject and activity combination.
#
########################################################################

# Load the libraries
library(dplyr)

# Load the data
# It's assumed that the working directory is set to the root directory where the README file is located

setwd("./UCI HAR Dataset")

#Load train data
data_train_labels <- read.table("train/y_train.txt")
data_train_subject <- read.table("train/subject_train.txt")
data_train_values <- read.table("train/X_train.txt")

#Load test data
data_test_labels <- read.table("test/y_test.txt")
data_test_subject <- read.table("test/subject_test.txt")
data_test_values <- read.table("test/X_test.txt")

#Put together train data. Columns: subject, activity, values
data_train_ready <- cbind(data_train_subject, data_train_labels, data_train_values)

#Put together test data. Columns: subject, activity, values
data_test_ready <- cbind(data_test_subject, data_test_labels, data_test_values)

#And join both tables in our working data table. This is, put all rows together
data_ready <- rbind(data_train_ready, data_test_ready)

#We need to extract the columns related to mean and standard deviation values.
#We could find the column's number, but it would be faster to use a regular expression, so we
# are going to do step 5 first (give names to variables).

data_columns_names <- read.table("features.txt")
# Extract the names
values_colnames<-as.vector(data_columns_names[,2])

# Use the names. First column is subject, second is activity.
names(data_ready)<- c("Subject", "Activity", values_colnames)

#Now we can select the columns with mean() or std() in the name
# NOTE: Columns for meanFreq are NOT included since these values seem like an input for the 
# Fast Fourier Transformation. 
# Also, the columns with the word "mean" in the name, but not referring to a mean value are NOT
# included. For example, angle(tBodyAccMean,gravity)

data_mean_std<-data_ready[, grep("mean\\(|std\\(|Subject|Activity", colnames(data_ready), value = TRUE)]

# Now let's give meaningful names to the activities.
# 1= WALKING, 2= WALKING_UPSTAIRS, 3= WALKING_DOWNSTAIRS, 4= SITTING, 5= STANDING, 6= LAYING

activity_names_vector <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

for (identifier in 1:6) {
    data_mean_std$Activity[data_mean_std$Activity == identifier] <- activity_names_vector[identifier]
}

# For the final task, let's group by Subject and Activity and calculate the mean using dplyr.

# Set data
data_mean_std_df<-tbl_df(data_mean_std)

# Group data
data_mean_std_df_grouped <- group_by(data_mean_std_df, Subject, Activity)

# And summarize all columns to calculate the average
data_final<-summarise_all(data_mean_std_df_grouped, funs(mean))

# Change the name of the columns to reflect the average
cols<-ncol(data_final)
colnames(data_final)[3:cols] <- paste("Average_", colnames(data_final)[3:cols], sep = "")

# Save the data
write.table(data_final, "AverageValue_Mean_STD.txt", row.names= FALSE)

# END
