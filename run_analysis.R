features <- read.table("features.txt")

activity <- rbind(read.table("test/y_test.txt"), 
                    read.table("train/y_train.txt"))

subject <- rbind(read.table("test/subject_test.txt"),
                  read.table("train/subject_train.txt"))

measurement <- rbind(read.table("test/X_test.txt"), 
                      read.table("train/X_train.txt"))

measurement <- cbind(measurement,
                      subject,
                      merge(activity, activity_labels)$V2)

names(measurement) <- append(gsub("[(),-]", "_", features$V2), "subject", "activity")

measure.vars <- grep("(mean|std)", names(measurement), value=TRUE)

mdata <- melt(measurement, id=c("subject","activity"), measure.vars=measure.vars)

tidyData <- ddply(mdata, c("activity", "subject", "variable"), summarise, mean = mean(value))

write.table(tidyData, "tidy.txt", row.names = FALSE)
