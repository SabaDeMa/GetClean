library(dplyr)

# Step1: Read data into R...
feature <- read.table("UCI HAR DATASET/features.txt", stringsAsFactors=FALSE)
# ... from"train" folder
data_train <- read.table("UCI HAR DATASET/train/X_train.txt")
labels_train <- read.table("UCI HAR DATASET/train/y_train.txt")
sub_train <- read.table("UCI HAR DATASET/train/subject_train.txt")
# ... from "test" folder
data_test <- read.table("UCI HAR DATASET/test/X_test.txt")
labels_test <- read.table("UCI HAR DATASET/test/y_test.txt")
sub_test <-  read.table("UCI HAR DATASET/test/subject_test.txt")

# Step2: Convert
feature1 <- tbl_df(feature)
data_train1 <- tbl_df(data_train)
labels_train1 <- tbl_df(labels_train)
sub_train1 <- tbl_df(sub_train)
data_test1 <- tbl_df(data_test)
labels_test1 <- tbl_df(labels_test)
sub_test1 <- tbl_df(sub_test)

# Step3: Select Names...
feature2 <- select(feature, 2)
feature3 <- as.vector(t(feature2))

#  ... and use Names
colnames(data_train1) <- feature3
colnames(data_test1) <- feature3
colnames(sub_train1) <- "Sub" # Subjects
colnames(sub_test1) <- "Sub"
colnames(labels_train1) <- "Act" # Activity Labels
colnames(labels_test1) <- "Act"

# Step4: Create merged versions for test and train...
data_train_fin <- tbl_df(cbind(labels_train1, sub_train1, data_train1))
data_test_fin <- tbl_df(cbind(labels_test1, sub_test1, data_test1))

# ... and add together the two databases
data_total <- tbl_df(rbind(data_train_fin, data_test_fin))

# Step5: Select Mean and std
data_1 <- data_total[ , grepl("mean|std", names(data_total))]

# Step6: Adjust Names 
names(data_1) <- gsub("-|tBody|fBody|\\()", "", names(data_1))
names(data_1) <- gsub("Gyro","GY", names(data_1))
names(data_1) <- gsub("Acc", "AC", names(data_1))

act_sub <- data_total[ , 1:2]
data_2 <- cbind(act_sub, data_1)
data_2 <- tbl_df(data_2)

# Step7: Change names because of duplicates.
nomi <- names(data_2)
por <- make.names(nomi, unique = TRUE)
names(data_2) <- por

# Step8: Change levels
activities <- c("Walking", "Walking_Up","Walking_down","Sitting","Standing","Lying")
data_2$Act <- as.factor(data_2$Act)
levels(data_2$Act) <- activities

# Step9: Group
data_3 <- group_by(data_2, Act, Sub)

# Step10: mean for each variable, activities and for each subjects
data_4 <- summarise_each(data_3, funs(mean))

# Step11: Write "data.txt"
write.table(data_4, file = "data.txt", row.name=FALSE, col.names = TRUE)