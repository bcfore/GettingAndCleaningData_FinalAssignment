library(data.table)
library(dplyr)

# I assume you have this as your current working directory:
dir.exists("../UCI HAR Dataset/")

# Read in the activity labels and the features:
activitylabels <- fread("activity_labels.txt", stringsAsFactors = T)
features <- fread("features.txt")

# --- Step 1:
#   Merge the training and test sets to create one data set.

# Read in and combine the Test and Training data:
ytotal <- rbind(fread("test/y_test.txt"), fread("train/y_train.txt"))
xtotal <- rbind(fread("test/X_test.txt"), fread("train/X_train.txt"))
subject <- rbind(fread("test/subject_test.txt"), fread("train/subject_train.txt"))

# --- Step 2:
#   Extract the "features" from xtotal that are means or stdevs.

# The variable names for x are stored in the "features" file.
# Assign those features as the col names for x.
xtotal <- setNames(xtotal, features$V2)

# Extract the "mean" and "std" columns from x:
xtotal <- select(xtotal, matches("-mean\\(|-std\\("))

# --- Step 3:
#   Use the activity labels to name the activities.

# The activity ids per observation are in ytotal.
# The activityid-to-activitylabel are in activitylabels.

# Create an "activityid" column name, so we can merge with ytotal.
names(activitylabels) <- c("activityid", "activity")

# Give ytotal the same col name.
names(ytotal) <- "activityid"

# Merge ytotal with activitylabels.
#
# After merging, ytotal's row order changes,
# which is a problem, since later I cbind with xtotal. So add the
# row order as an explicit column, and re-order after the merge. 
ytotal %>%
  mutate(roworder = as.numeric(row.names(ytotal))) %>%
  merge(activitylabels, by = "activityid") %>%
  arrange(roworder) -> ytotal

# --- Step 4:
#   Appropriately label the data set.

# The only column that's not named yet is the "subject".
names(subject) <- "subject"
# Convert it to a factor:
subject$subject <- factor(subject$subject)

# Add the activities (from ytotal) and the
# subjects (from subject) as columns to x:
xtotal$activity <- ytotal$activity
xtotal$subject <- subject

# --- Step 5:
#   Create a new data set (xtotalAve) with the averages per subject/activity.

xtotal %>%
  group_by(activity, subject) %>%
  summarize_each(funs(mean)) %>%
  arrange(subject, activity) -> xtotalAve

newnames <- paste0(names(xtotalAve), "-timeAve")
newnames[1:2] <- names(xtotalAve)[1:2]
names(xtotalAve) <- newnames

# # Do a quick check using one of the data columns:
# xtotalAve %>% select(1:3) %>% rename(amean = `tBodyAcc-mean()-X-timeAve`) -> quickcheck
# xtabs(amean ~ subject + activity, data = quickcheck)

# To upload:
write.table(xtotalAve, "xtotalAve.txt", row.names = F)
# # To check:
#write.csv(xtotalAve, "xtotalAve.csv", row.names = F)



