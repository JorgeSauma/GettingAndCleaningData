# Average value for mean and std calculations data

Course: Getting and Cleaning Data

By: Jorge Sauma

Date: 09/14/2017
 
The UCI Dataset includes measurements for 561 features for 30 subjects doing any of 6 activities types. The goal of this code is to extract the information from this data and calculate the average value for variables which the mean and std were already calculated. For example, tBodyAcc-mean()-X and tBodyAcc-std()-X.

Also, the average will be calculated for the combination of subject and activity. For example, subject 1 walking is one measurement, subject 2 laying is another measurement. 

The included script loads the training and testing data from the UCI Dataset and merge them together in a single file. Also, the subject and the Activity are added as the first variables in order to bind this info with the measurments.

Once the data is merged, the average for the combination subject-activity-feature is calculated for each variable related with the mean or the std calculations. The resulting variables would
be called Average_tBodyAcc-mean()-X and Average_tBodyAcc-std()-X.

To make the data set more clear, the column Activity has the name of
the activity instead of the activity id.
 
The final dataset is stored in the AverageValue_Mean_STD.txt file

The dataset complies with the tidy data rules described in 
https://www.jstatsoft.org/article/view/v059i10/v59i10.pdf

These rules are:
>     1. Each variable forms a column: the average value is for just one feature
>     2. Each observation forms a row: each observation is for one subject doing one activity
>     3. Each type of observational unit forms a table: the table is juts for averages for the subject and activity combination.
