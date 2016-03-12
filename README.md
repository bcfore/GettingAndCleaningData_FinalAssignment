## Week 4 assignment for Getting and Cleaning Data
bcfore  
12-Mar-2016

See the _codebook_for_assignment.md_ for my understanding of the original data, the modifications I did to the data per the assignment specifications, and the information on the variables.

My final data set gets stored in:  
_xtotalAve.txt_

Briefly, it contains a summarized subset of measurements of the original data.
Each row represents a unique subject/activity pair.
The variables are a subset of the measurements done in the original data set.
The values are the time averages of the variables, per subject/activity pair.
See the codebook for more info.

The script used to generate the xtotalAve.txt file is given in:  
_run_analysis.R_

Before running the script, set your working directory to "UCI HAR Dataset" (the top-level directory containing the original data).

The script is divided into 5 steps, as per the assignment specifications.

### --- Step 1: Merge the training and test sets to create one data set.

The test and training data are stored in the "test" and "training" sub folders.
Within both folders, there are three relevant files: y.txt, x.txt, and subject.txt.
I combine the "y" test and training data into a single data table called "ytotal".
I do the same for the "x" data ("xtotal") and the subject data ("subject").

### --- Step 2: Extract the "features" from xtotal that are means or stdevs.

I read in the features.txt file and assigned these "features" to xtotal's column names.
I then selected only those features that ended in "-mean()" or "-std()", dropping the rest of the columns from xtotal.
(I didn't include the features ending in "Mean".)

### --- Step 3: Use the activity labels to name the activities.

The rows of the ytotal data table contain the activity ids, labeled as ints 1-6. The mapping from int to activity label was stored in the activity_label.txt file.  I read this into the activitylabels data table.

I label the "activityid" column in both ytotal and activitylabels, then "merge" on the activitylabel.  This adds a column to ytotal that contains the appropriate activity names ("walking", "sitting", etc).

I had to take care with the rows -- merging changes the row order, so to get back to the original row order, I first added a column to ytotal containing the row numbers, then did the merge, and then did a sort ("arrange") after the merge.

### --- Step 4: Appropriately label the data set.

At this point, the only column not yet labeled was the "subject" id in the "subject" data table, so I labeled that.
I also converted it to a factor, to make it easier to group by "subject" later on.

I then column-combine the three tables: xtotal, ytotal, and subject.
In fact, I just add a couple of columns to xtotal: the "activity" column from ytotal, and the "subject" column from the "subject" table.

### --- Step 5: Create a new data set (xtotalAve) with the averages per subject/activity.

For the new table "xtotalAve", I take the xtotal table and calculate the averages across the variables, per activity, per subject. So in the end we should be left with a table with 180 rows (being the 6 activities x the 30 subjects), with each column being the average for that particular variable.
I append the string "-timeAve" onto the variables of xtotalAve to indicate that I took the average of the original variables.

### --- Final steps:
Then in the script, I commented out some lines where I did a basic check, and then I write out the table xtotalAve.txt.



